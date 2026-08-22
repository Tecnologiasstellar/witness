import Testing
@testable import WitnessCore

@Suite("Truthful sharing")
struct WitnessShareCopyTests {
    @Test("Share copy names the species and avoids impact claims")
    func truthfulShareCopy() throws {
        let species = try #require(BundledSpeciesCatalog.load().first)
        let copy = WitnessShareCopy.make(for: species)

        #expect(copy.contains("Vaquita"))
        #expect(copy.contains(species.action.destinationURL))
        #expect(!copy.localizedCaseInsensitiveContains("people witnessed"))
        #expect(!copy.localizedCaseInsensitiveContains("saved"))
        #expect(!copy.localizedCaseInsensitiveContains("impact"))
    }
}
