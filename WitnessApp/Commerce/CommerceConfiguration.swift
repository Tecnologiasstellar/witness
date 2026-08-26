import Foundation

/// Commerce provider configuration. The RevenueCat public Apple SDK key is
/// supplied by an untracked local plist (`RevenueCatConfig.plist`, see
/// `.gitignore`) so no key of any kind lives in source control. A missing
/// configuration is a valid state: the app runs the free ritual and, in
/// Debug, the local StoreKit harness.
struct CommerceConfiguration {
    enum ValidationError: Error, Equatable {
        case testStoreKeyInRelease
        case malformedKey
    }

    let revenueCatAPIKey: String?

    static func load(bundle: Bundle = .main) -> CommerceConfiguration {
        guard
            let url = bundle.url(forResource: "RevenueCatConfig", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = plist["apiKey"] as? String,
            !key.isEmpty
        else {
            return CommerceConfiguration(revenueCatAPIKey: nil)
        }
        return CommerceConfiguration(revenueCatAPIKey: key)
    }

    /// RevenueCat public Apple App Store SDK keys start with `appl_`;
    /// Test Store keys start with `test_`. Only `appl_` may ever reach a
    /// Release build, and secret keys (`sk_`) must never be in the app.
    static func validate(key: String, isReleaseBuild: Bool) -> ValidationError? {
        if key.hasPrefix("sk_") { return .malformedKey }
        if key.hasPrefix("test_") {
            return isReleaseBuild ? .testStoreKeyInRelease : nil
        }
        if key.hasPrefix("appl_") { return nil }
        return .malformedKey
    }

    /// Returns a key safe for the current build configuration, or nil when
    /// commerce must stay disabled. Never crashes the free ritual.
    func usableKey() -> String? {
        guard let revenueCatAPIKey else { return nil }
#if DEBUG
        let isRelease = false
#else
        let isRelease = true
#endif
        guard Self.validate(key: revenueCatAPIKey, isReleaseBuild: isRelease) == nil else {
            assertionFailure("Rejected commerce configuration for this build type")
            return nil
        }
        return revenueCatAPIKey
    }
}
