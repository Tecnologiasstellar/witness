import Foundation

public enum BundledSpeciesCatalog {
    public static func load() throws -> [SpeciesRecord] {
        guard let url = resourceBundle.url(forResource: "species", withExtension: "json") else {
            throw CatalogValidationError(issues: ["Bundled species.json is missing."])
        }

        let data = try Data(contentsOf: url)
        let records = try JSONDecoder().decode([SpeciesRecord].self, from: data)
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
