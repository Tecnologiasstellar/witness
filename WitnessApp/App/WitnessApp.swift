import SwiftUI
import WitnessCore

@main
struct WitnessApp: App {
    @StateObject private var model = AppModel()
    @StateObject private var commerce = Self.makeCommerceModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootTabView(model: model, commerce: commerce)
                .onChange(of: scenePhase) { _, phase in
                    guard phase == .active else { return }
                    Task.detached {
                        await WitnessSync.shared.drain()
                    }
                    Task { await commerce.refreshAccess() }
                }
        }
    }

    /// Commerce composition (D-020/D-021). Debug builds use the local
    /// StoreKit adapter (driven by `Witness.storekit` when the scheme
    /// attaches it); UI tests may force the deterministic fake. With a
    /// configured RevenueCat key the production adapter takes over. Without
    /// one, Release exposes no purchase execution — the free ritual and any
    /// cached verified access still work.
    @MainActor
    private static func makeCommerceModel() -> CommerceModel {
        let repository = FileAccessRepository(fileURL: accessCacheURL)
        let configuration = CommerceConfiguration.load()
#if DEBUG
        if ProcessInfo.processInfo.environment["WITNESS_COMMERCE"] == "fake" {
            return CommerceModel(purchaseService: FakePurchaseService(), accessRepository: repository)
        }
        if let apiKey = configuration.usableKey() {
            RevenueCatPurchaseAdapter.configure(apiKey: apiKey)
            return CommerceModel(purchaseService: RevenueCatPurchaseAdapter(), accessRepository: repository)
        }
        return CommerceModel(purchaseService: StoreKitPurchaseAdapter(), accessRepository: repository)
#else
        if let apiKey = configuration.usableKey() {
            RevenueCatPurchaseAdapter.configure(apiKey: apiKey)
            return CommerceModel(purchaseService: RevenueCatPurchaseAdapter(), accessRepository: repository)
        }
        return CommerceModel(purchaseService: UnavailablePurchaseService(), accessRepository: repository)
#endif
    }

    private static var accessCacheURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
#if DEBUG
        if let testArchive = ProcessInfo.processInfo.environment["WITNESS_TEST_ARCHIVE"],
           !testArchive.isEmpty {
            return base
                .appendingPathComponent("WitnessUITests", isDirectory: true)
                .appendingPathComponent("\(testArchive)-access.json")
        }
#endif
        return base
            .appendingPathComponent("Witness", isDirectory: true)
            .appendingPathComponent("access-cache.json")
    }
}
