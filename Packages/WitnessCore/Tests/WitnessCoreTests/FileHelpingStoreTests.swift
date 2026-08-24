import Foundation
import Testing
@testable import WitnessCore

@Suite struct FileHelpingStoreTests {
    private func makeStoreURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("witness-helping-tests", isDirectory: true)
            .appendingPathComponent("\(UUID().uuidString).json")
    }

    @Test func firstMarkPersistsAcrossInstances() async throws {
        let url = makeStoreURL()
        let first = FileHelpingStore(fileURL: url)
        let record = try await first.startHelping(speciesID: "vaquita", at: Date(timeIntervalSince1970: 100))
        #expect(record.speciesID == "vaquita")

        let second = FileHelpingStore(fileURL: url)
        let restored = try await second.allRecords()
        #expect(restored == [record])
    }

    @Test func markingTwiceKeepsTheOriginalDate() async throws {
        let store = FileHelpingStore(fileURL: makeStoreURL())
        let original = try await store.startHelping(speciesID: "vaquita", at: Date(timeIntervalSince1970: 100))
        let repeated = try await store.startHelping(speciesID: "vaquita", at: Date(timeIntervalSince1970: 999))
        #expect(repeated == original)
        #expect(try await store.allRecords().count == 1)
    }
}
