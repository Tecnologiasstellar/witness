import Foundation
import SwiftUI
import WitnessCore

@MainActor
final class AppModel: ObservableObject {
    @Published private(set) var species: SpeciesRecord?
    @Published private(set) var loadError: String?
    @Published private(set) var witnessRecords: [WitnessRecord] = []
    @Published private(set) var persistenceError: String?
    @Published private(set) var isSaving = false
    @Published var reflectionDraft = ""

    private let witnessRepository: any WitnessRepository
    private let dateProvider: any DateProviding
    private var calendar: Calendar

    var currentWeekWitnessRecord: WitnessRecord? {
        guard let species else { return nil }
        let period = WitnessPeriodKey.make(for: dateProvider.now(), calendar: calendar)
        let eventID = WitnessPeriodKey.eventID(speciesID: species.id, period: period)
        return witnessRecords.first(where: { $0.id == eventID })
    }

    var latestWitnessRecord: WitnessRecord? { witnessRecords.first }
    var isWitnessed: Bool { currentWeekWitnessRecord != nil }
    var currentStreak: Int {
        WitnessStreakCalculator.currentStreak(
            records: witnessRecords,
            asOf: dateProvider.now(),
            calendar: calendar
        )
    }

    init(
        witnessRepository: (any WitnessRepository)? = nil,
        dateProvider: any DateProviding = SystemDateProvider(),
        calendar: Calendar = .current
    ) {
        self.witnessRepository = witnessRepository ?? FileWitnessRepository(fileURL: Self.defaultArchiveURL)
        self.dateProvider = dateProvider
        self.calendar = calendar

        do {
            let catalog = try BundledSpeciesCatalog.load()
            species = WeeklySpeciesSelector().species(for: dateProvider.now(), from: catalog, calendar: calendar)
        } catch {
            loadError = String(describing: error)
        }

        Task { [weak self] in
            await self?.restoreWitnesses()
        }
    }

    func witness() async {
        guard let species, !isSaving else { return }
        isSaving = true
        defer { isSaving = false }

        let now = dateProvider.now()
        let assignedPeriod = WitnessPeriodKey.make(for: now, calendar: calendar)
        do {
            _ = try await witnessRepository.recordWitness(
                speciesID: species.id,
                assignedPeriod: assignedPeriod,
                witnessedAt: now
            )
            persistenceError = nil
            await restoreWitnesses()
        } catch {
            persistenceError = "Your Witness could not be saved yet. Nothing was sent or counted. \(error.localizedDescription)"
        }
    }

    func saveReflection() async {
        guard let record = latestWitnessRecord, !isSaving else { return }
        isSaving = true
        defer { isSaving = false }

        do {
            _ = try await witnessRepository.updateReflection(
                eventID: record.id,
                reflection: reflectionDraft
            )
            persistenceError = nil
            await restoreWitnesses()
        } catch {
            persistenceError = "Your private reflection could not be saved. \(error.localizedDescription)"
        }
    }

    func restoreWitnesses() async {
        do {
            witnessRecords = try await witnessRepository.allRecords()
            reflectionDraft = latestWitnessRecord?.reflection ?? ""
            persistenceError = nil
        } catch {
            persistenceError = "Your private Witness archive could not be opened. \(error.localizedDescription)"
        }
    }

    private static var defaultArchiveURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
#if DEBUG
        if let testArchive = ProcessInfo.processInfo.environment["WITNESS_TEST_ARCHIVE"],
           !testArchive.isEmpty {
            return base
                .appendingPathComponent("WitnessUITests", isDirectory: true)
                .appendingPathComponent("\(testArchive).json")
        }
#endif
        return base
            .appendingPathComponent("Witness", isDirectory: true)
            .appendingPathComponent("witness-archive.json")
    }
}
