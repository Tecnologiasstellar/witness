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
        // Every chapter with audio must carry the synthetic-voice disclosure.
        for chapter in edition.chapters {
            if let audio = chapter.audio, audio.voiceDisclosure.isEmpty {
                return nil
            }
        }
        return edition
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
