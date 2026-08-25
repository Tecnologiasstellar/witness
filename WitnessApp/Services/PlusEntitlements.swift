import Foundation
import RevenueCat

/// The app's single source of truth for the Witness+ ("plus") entitlement
/// (D-016). Wraps the RevenueCat SDK; nothing outside this file imports it.
@MainActor
final class PlusEntitlements: ObservableObject {
    static let shared = PlusEntitlements()
    static let entitlementID = "plus"

    @Published private(set) var hasPlus = false
    @Published private(set) var packages: [Package] = []
    @Published private(set) var isWorking = false
    @Published private(set) var lastError: String?

    /// Call once at launch. Failure to reach RevenueCat leaves the app in the
    /// free state; the ritual never depends on this.
    func configure() {
        guard !Purchases.isConfigured else { return }
        Purchases.logLevel = .warn
        Purchases.configure(withAPIKey: BackendConfig.revenueCatAPIKey)

        Task { [weak self] in
            for await info in Purchases.shared.customerInfoStream {
                self?.apply(info)
            }
        }
        Task { await refreshOfferings() }
    }

    func refreshOfferings() async {
        guard Purchases.isConfigured else { return }
        do {
            packages = try await Purchases.shared.offerings().current?.availablePackages ?? []
        } catch {
            lastError = error.localizedDescription
        }
    }

    func purchase(_ package: Package) async {
        guard !isWorking else { return }
        isWorking = true
        defer { isWorking = false }
        do {
            let result = try await Purchases.shared.purchase(package: package)
            apply(result.customerInfo)
            lastError = nil
            if !result.userCancelled {
                let sync = WitnessSync.shared
                Task.detached {
                    await sync.logEvent("purchase_completed", metadata: ["package": package.identifier])
                }
            }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func restore() async {
        guard Purchases.isConfigured, !isWorking else { return }
        isWorking = true
        defer { isWorking = false }
        do {
            apply(try await Purchases.shared.restorePurchases())
            lastError = nil
        } catch {
            lastError = error.localizedDescription
        }
    }

    private func apply(_ info: CustomerInfo) {
        hasPlus = info.entitlements[Self.entitlementID]?.isActive == true
    }
}
