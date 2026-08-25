import Foundation

public enum BundledSpeciesCatalog {
    public static func load() throws -> [SpeciesRecord] {
        // One file per species in Resources/catalog/ so 30 cards stay reviewable;
        // scaffold new ones with tools/new-card.py.
        guard let urls = resourceBundle.urls(forResourcesWithExtension: "json", subdirectory: "catalog"),
              !urls.isEmpty else {
            throw CatalogValidationError(issues: ["Bundled catalog/ species files are missing."])
        }

        let decoder = JSONDecoder()
        let records = try urls
            .map { try decoder.decode(SpeciesRecord.self, from: Data(contentsOf: $0)) }
            .sorted {
                if $0.publishDate == $1.publishDate { return $0.id < $1.id }
                return $0.publishDate < $1.publishDate
            }
        try CatalogValidator.validate(records, mode: .prototype)
        return records
    }

    private static var resourceBundle: Bundle {
#if SWIFT_PACKAGE
        Bundle.module
#else
        Bundle(for: BundleToken.self)
#endif
    }
}

private final class BundleToken {}
