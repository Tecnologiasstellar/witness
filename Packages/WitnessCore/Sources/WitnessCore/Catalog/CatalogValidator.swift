import Foundation

public enum CatalogValidationMode: Sendable {
    case prototype
    case production
}

public struct CatalogValidationError: Error, Equatable, CustomStringConvertible, Sendable {
    public let issues: [String]

    public init(issues: [String]) {
        self.issues = issues
    }

    public var description: String {
        issues.joined(separator: "\n")
    }
}

public enum CatalogValidator {
    public static func validate(
        _ records: [SpeciesRecord],
        mode: CatalogValidationMode = .prototype
    ) throws {
        var issues: [String] = []

        if records.isEmpty {
            issues.append("Catalog must contain at least one species.")
        }

        let duplicateIDs = Dictionary(grouping: records, by: \SpeciesRecord.id)
            .filter { $0.value.count > 1 }
            .keys
            .sorted()
        if !duplicateIDs.isEmpty {
            issues.append("Duplicate species IDs: \(duplicateIDs.joined(separator: ", ")).")
        }

        for record in records {
            let prefix = "[\(record.id.isEmpty ? "missing-id" : record.id)]"
            if record.schemaVersion < 1 { issues.append("\(prefix) schemaVersion must be at least 1.") }
            if record.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { issues.append("\(prefix) id is required.") }
            if record.commonName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { issues.append("\(prefix) commonName is required.") }
            if record.scientificName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { issues.append("\(prefix) scientificName is required.") }
            if record.generalizedRange.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { issues.append("\(prefix) generalizedRange is required.") }
            if !isISODate(record.publishDate) { issues.append("\(prefix) publishDate must use YYYY-MM-DD.") }

            let words = record.story
                .map(\.text)
                .joined(separator: " ")
                .split { $0.isWhitespace || $0.isNewline }
                .count
            if !(120...220).contains(words) {
                issues.append("\(prefix) story must contain 120 to 220 words; found \(words).")
            }

            let sourceIDs = Set(record.sources.map(\.id))
            if sourceIDs.count != record.sources.count {
                issues.append("\(prefix) source IDs must be unique.")
            }
            for source in record.sources {
                if !isHTTPSURL(source.url) { issues.append("\(prefix) source \(source.id) must use HTTPS.") }
                if !isISODate(source.lastAccessed) { issues.append("\(prefix) source \(source.id) lastAccessed must use YYYY-MM-DD.") }
            }
            for section in record.story where section.sourceIDs.isEmpty || !Set(section.sourceIDs).isSubset(of: sourceIDs) {
                issues.append("\(prefix) story section \(section.id) must map only to declared sources.")
            }
            if record.action.sourceIDs.isEmpty || !Set(record.action.sourceIDs).isSubset(of: sourceIDs) {
                issues.append("\(prefix) action must map only to declared sources.")
            }
            if !isHTTPSURL(record.action.destinationURL) { issues.append("\(prefix) action destination must use HTTPS.") }
            if !isISODate(record.action.lastVerified) { issues.append("\(prefix) action lastVerified must use YYYY-MM-DD.") }
            if record.media.assetID.isEmpty || record.media.commercialUseStatus.isEmpty || record.media.license.isEmpty {
                issues.append("\(prefix) media provenance and commercial-use status are required.")
            }
            if !isISODate(record.editorial.lastFactChecked) {
                issues.append("\(prefix) editorial lastFactChecked must use YYYY-MM-DD.")
            }
            if record.editorial.sensitiveLocationReview != "generalized" {
                issues.append("\(prefix) sensitive location review must be generalized.")
            }

            switch mode {
            case .prototype:
                if ![ReviewState.prototype, .approved].contains(record.editorial.state) {
                    issues.append("\(prefix) prototype catalog requires prototype or approved editorial state.")
                }
            case .production:
                if record.editorial.state != .approved {
                    issues.append("\(prefix) production catalog requires approved editorial state.")
                }
                if record.media.verificationStatus != .approved {
                    issues.append("\(prefix) production catalog requires approved media rights.")
                }
            }
        }

        if !issues.isEmpty {
            throw CatalogValidationError(issues: issues)
        }
    }

    private static func isHTTPSURL(_ value: String) -> Bool {
        guard let components = URLComponents(string: value) else { return false }
        return components.scheme == "https" && components.host != nil
    }

    private static func isISODate(_ value: String) -> Bool {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = false
        guard let date = formatter.date(from: value) else { return false }
        return formatter.string(from: date) == value
    }
}
