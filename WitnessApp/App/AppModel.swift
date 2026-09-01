import Foundation
import SwiftUI
import WitnessCore

@MainActor
final class AppModel: ObservableObject {
    @Published private(set) var species: SpeciesRecord?
    @Published private(set) var catalog: [SpeciesRecord] = []
    @Published private(set) var loadError: String?
    @Published private(set) var witnessRecords: [WitnessRecord] = []
    @Published private(set) var persistenceError: String?
    @Published private(set) var isSaving = false
    @Published private(set) var witnessCount: Int?
    @Published private(set) var helpingRecords: [HelpingRecord] = []
    @Published var reflectionDraft = ""

    private let witnessRepository: any WitnessRepository
    private let helpingStore: FileHelpingStore
    private let dateProvider: any DateProviding
    private var calendar: Calendar

    var currentWeekWitnessRecord: WitnessRecord? {
        guard let species else { return nil }
        let period = WitnessPeriodKey.make(for: dateProvider.now(), calendar: calendar)
        let eventID = WitnessPeriodKey.eventID(speciesID: species.id, period: period)
        return witnessRecords.first(where: { $0.id == eventID })
    }

    var latestWitnessRecord: WitnessRecord? { witnessRecords.first }

    var featuredPlates: [FeaturedPlate] {
        WeeklySpeciesSelector().featuredHistory(asOf: dateProvider.now(), from: catalog, calendar: calendar)
    }

    func isPlateUnlocked(_ plate: FeaturedPlate, atlasActive: Bool) -> Bool {
        ArchiveAccessPolicy.isUnlocked(
            period: plate.period,
            asOf: dateProvider.now(),
            calendar: calendar,
            atlasActive: atlasActive
        )
    }

    func isPlateWitnessed(_ plate: FeaturedPlate) -> Bool {
        let eventID = WitnessPeriodKey.eventID(speciesID: plate.species.id, period: plate.period)
        return witnessRecords.contains { $0.id == eventID }
    }

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
        self.helpingStore = FileHelpingStore(fileURL: Self.helpingStoreURL)
        self.dateProvider = dateProvider
        self.calendar = calendar

        do {
            catalog = try BundledSpeciesCatalog.load()
            species = WeeklySpeciesSelector().species(for: dateProvider.now(), from: catalog, calendar: calendar)
#if DEBUG
            if let forced = ProcessInfo.processInfo.environment["WITNESS_FORCE_SPECIES"],
               let match = catalog.first(where: { $0.id == forced }) {
                species = match
            }
#endif
        } catch {
            loadError = String(describing: error)
        }

        Task { [weak self] in
            await self?.restoreWitnesses()
            await self?.restoreHelping()
            await self?.refreshWitnessCount()
        }
    }

    func restoreHelping() async {
        helpingRecords = (try? await helpingStore.allRecords()) ?? []
    }

    func helpingRecord(for speciesID: String) -> HelpingRecord? {
        helpingRecords.first { $0.speciesID == speciesID }
    }

    func startHelping(speciesID: String) async {
        guard helpingRecord(for: speciesID) == nil else { return }
        _ = try? await helpingStore.startHelping(speciesID: speciesID, at: dateProvider.now())
        await restoreHelping()
        Task.detached {
            await WitnessSync.shared.logEvent("helping_started", metadata: ["species": speciesID])
        }
    }

    /// Every species the user has witnessed, newest first, with dates.
    var witnessedCollection: [(species: SpeciesRecord, witnessedAt: Date, helping: HelpingRecord?)] {
        var seen = Set<String>()
        return witnessRecords.compactMap { record in
            guard !seen.contains(record.speciesID),
                  let species = catalog.first(where: { $0.id == record.speciesID }) else { return nil }
            seen.insert(record.speciesID)
            return (species, record.witnessedAt, helpingRecord(for: record.speciesID))
        }
    }

    func refreshWitnessCount() async {
        guard let species else { return }
        if let count = await WitnessCounts.fetch(speciesID: species.id) {
            witnessCount = count
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
            Task { [weak self] in
                await WitnessSync.shared.witnessRecorded(speciesID: species.id, assignedPeriod: assignedPeriod)
                await self?.refreshWitnessCount()
            }
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
            Task.detached {
                // Name only; reflection content never leaves the device.
                await WitnessSync.shared.logEvent("reflection_saved")
            }
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

    /// Helping records sit beside the witness archive. Under a UI-test
    /// archive the file is keyed per run like the archive itself —
    /// otherwise runs share one helping.json and leak state into each
    /// other. The production path is unchanged so no device records move.
    private static var helpingStoreURL: URL {
#if DEBUG
        if let testArchive = ProcessInfo.processInfo.environment["WITNESS_TEST_ARCHIVE"],
           !testArchive.isEmpty {
            return defaultArchiveURL
                .deletingPathExtension()
                .appendingPathExtension("helping.json")
        }
#endif
        return defaultArchiveURL
            .deletingLastPathComponent()
            .appendingPathComponent("helping.json")
    }
}
