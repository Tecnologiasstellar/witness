import Foundation
import SwiftUI
import WitnessCore

/// Honest community-count state for the ritual. The server response, never
/// optimistic UI, determines the number: a queued event shows as pending,
/// a missing backend keeps the app fully local, and failure states never
/// block or degrade the private ritual.
@MainActor
final class CommunityModel: ObservableObject {
    enum CountState: Equatable {
        /// No backend is configured; the ritual is private and local only.
        case localOnly
        /// The Witness is recorded locally and queued; the collective count
        /// has not been reconciled yet.
        case pendingReconciliation
        /// The authoritative server count.
        case reconciled(Int64)
        /// The backend exists but could not be reached for a count.
        case unavailable
    }

    @Published private(set) var countState: CountState

    private let service: (any RemoteWitnessEventService)?
    private let outbox: WitnessEventOutbox

    init(service: (any RemoteWitnessEventService)?, outbox: WitnessEventOutbox) {
        self.service = service
        self.outbox = outbox
        self.countState = service == nil ? .localOnly : .unavailable
    }

    var isEnabled: Bool { service != nil }

    /// Called after a Witness is stored locally. Queues the event durably,
    /// then attempts submission. Local success never depends on this.
    func witnessRecorded(speciesID: String, assignedPeriod: String, witnessedAt: Date) async {
        guard service != nil else { return }
        let now = Date()
        do {
            _ = try await outbox.enqueue(
                speciesID: speciesID,
                assignedPeriod: assignedPeriod,
                occurredAt: witnessedAt,
                now: now
            )
            if countState == .unavailable { countState = .pendingReconciliation }
        } catch {
            // The private record exists; the queue will retry from refresh.
        }
        await flush(currentSpeciesID: speciesID, currentPeriod: assignedPeriod)
    }

    /// Flushes due queued events and refreshes the displayed count for the
    /// current species and period.
    func refresh(speciesID: String, assignedPeriod: String) async {
        guard service != nil else { return }
        await flush(currentSpeciesID: speciesID, currentPeriod: assignedPeriod)
        await fetchCount(speciesID: speciesID, assignedPeriod: assignedPeriod)
    }

    private func flush(currentSpeciesID: String, currentPeriod: String) async {
        guard let service else { return }
        let now = Date()
        guard let due = try? await outbox.dueEvents(now: now) else { return }
        for event in due {
            do {
                let reconciled = try await service.submit(event)
                try? await outbox.markSubmitted(id: event.id)
                if reconciled.speciesID == currentSpeciesID,
                   reconciled.assignedPeriod == currentPeriod {
                    countState = .reconciled(reconciled.witnessCount)
                }
            } catch {
                try? await outbox.markFailed(id: event.id, now: now)
            }
        }
        let stillQueued = ((try? await outbox.allEvents()) ?? []).contains {
            $0.speciesID == currentSpeciesID && $0.assignedPeriod == currentPeriod
        }
        if stillQueued { countState = .pendingReconciliation }
    }

    private func fetchCount(speciesID: String, assignedPeriod: String) async {
        guard let service else { return }
        if countState == .pendingReconciliation { return }
        do {
            let reconciled = try await service.count(speciesID: speciesID, assignedPeriod: assignedPeriod)
            countState = .reconciled(reconciled.witnessCount)
        } catch {
            if case .reconciled = countState {} else { countState = .unavailable }
        }
    }

    /// Quiet one-line caption for the witnessed plate. Nil when the app is
    /// local-only (the existing private-record copy already tells the truth).
    var witnessedCountLine: String? {
        switch countState {
        case .localOnly:
            return nil
        case .pendingReconciliation:
            return "COUNT PENDING · KEPT SAFELY ON DEVICE"
        case .reconciled(let count):
            let formatted = count.formatted(.number.grouping(.automatic))
            return count == 1
                ? "THE FIRST WITNESS RECORDED THIS WEEK"
                : "COUNTED AMONG \(formatted) WITNESSES THIS WEEK"
        case .unavailable:
            return "COLLECTIVE COUNT UNAVAILABLE RIGHT NOW"
        }
    }
}
