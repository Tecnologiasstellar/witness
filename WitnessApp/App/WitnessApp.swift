import SwiftUI
import WitnessCore

@main
struct WitnessApp: App {
    @StateObject private var model = AppModel()
    @StateObject private var commerce = Self.makeCommerceModel()
    @StateObject private var community = Self.makeCommunityModel()

    var body: some Scene {
        WindowGroup {
            RootTabView(model: model, commerce: commerce, community: community)
        }
    }

    /// Community composition. Without a configured backend the ritual stays
    /// fully local; UI tests may force the deterministic fake.
    @MainActor
    private static func makeCommunityModel() -> CommunityModel {
        let outbox = WitnessEventOutbox(fileURL: supportURL(testSuffix: "-outbox", filename: "witness-outbox.json"))
#if DEBUG
        if ProcessInfo.processInfo.environment["WITNESS_COMMUNITY"] == "fake" {
            return CommunityModel(service: FakeRemoteWitnessEventService(), outbox: outbox)
        }
#endif
        if let configuration = SupabaseConfiguration.load() {
            return CommunityModel(
                service: SupabaseCommunityService(configuration: configuration),
                outbox: outbox
            )
        }
        return CommunityModel(service: nil, outbox: outbox)
    }

    /// Commerce composition. Debug builds use the local StoreKit adapter
    /// (driven by `Witness.storekit` when the scheme attaches it); UI tests
    /// may force the deterministic fake. Release builds expose no purchase
    /// execution until the production RevenueCat adapter lands — the free
    /// ritual and any cached verified access still work.
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
        supportURL(testSuffix: "-access", filename: "access-cache.json")
    }

    private static func supportURL(testSuffix: String, filename: String) -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
#if DEBUG
        if let testArchive = ProcessInfo.processInfo.environment["WITNESS_TEST_ARCHIVE"],
           !testArchive.isEmpty {
            return base
                .appendingPathComponent("WitnessUITests", isDirectory: true)
                .appendingPathComponent("\(testArchive)\(testSuffix).json")
        }
#endif
        return base
            .appendingPathComponent("Witness", isDirectory: true)
            .appendingPathComponent(filename)
    }
}
