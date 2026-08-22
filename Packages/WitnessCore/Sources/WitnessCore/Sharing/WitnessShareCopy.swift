import Foundation

public enum WitnessShareCopy {
    public static func make(for species: SpeciesRecord) -> String {
        """
        Today I witnessed the \(species.commonName) (\(species.scientificName)).

        \(species.hook)

        Learn from \(species.action.destinationOrganization): \(species.action.destinationURL)

        Witness — remember what is still here.
        """
    }
}
