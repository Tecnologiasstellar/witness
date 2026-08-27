import Foundation

/// Loads the bundled Field Season edition. Fail closed: a missing or
/// malformed edition returns nil and the app simply shows no reader —
/// never a broken or partial premium surface.
public enum FieldSeasonLoader {
    public static func loadBundledEdition(bundle: Bundle? = nil) -> FieldSeasonEdition? {
        let bundle = bundle ?? resourceBundle
        guard let url = bundle.url(
            forResource: "field-season-1",
            withExtension: "json",
            subdirectory: "fieldseason"
        ) ?? bundle.url(forResource: "field-season-1", withExtension: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url),
              let edition = try? JSONDecoder().decode(FieldSeasonEdition.self, from: data),
              !edition.chapters.isEmpty else {
            return nil
        }
        guard isValid(edition) else { return nil }
        return edition
    }

    /// Every chapter with audio must carry the synthetic-voice disclosure,
    /// and every action door must lead somewhere real: named, explained,
    /// and reached over https. Anything less and the edition fails closed.
    public static func isValid(_ edition: FieldSeasonEdition) -> Bool {
        for chapter in edition.chapters {
            if let audio = chapter.audio, audio.voiceDisclosure.isEmpty {
                return false
            }
            for section in chapter.sections where section.style == .action {
                for entry in section.entries {
                    guard let url = entry.url,
                          url.hasPrefix("https://"),
                          URL(string: url) != nil,
                          entry.lead?.isEmpty == false,
                          !entry.text.isEmpty else {
                        return false
                    }
                }
            }
        }
        return true
    }

    private static var resourceBundle: Bundle {
#if SWIFT_PACKAGE
        Bundle.module
#else
        Bundle(for: FieldSeasonBundleToken.self)
#endif
    }
}

private final class FieldSeasonBundleToken {}
