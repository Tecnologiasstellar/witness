import SwiftUI
import RevenueCat

/// The Witness+ sheet (D-016). Shown only at premium boundaries and from the
/// Index — never during onboarding (D-008). Copy makes no conservation-outcome
/// claim and states plainly that the ritual stays free.
struct WitnessPlusPaywall: View {
    @ObservedObject private var entitlements = PlusEntitlements.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("WITNESS+")
                        .font(AtlasType.display(34, weight: .semibold))

                    VStack(alignment: .leading, spacing: 0) {
                        promiseRow("THE DAILY RITUAL STAYS FREE FOR EVERYONE")
                        promiseRow("THE COMPLETE CABINET, BACK TO DAY ONE")
                        promiseRow("EVERY FUTURE PLATE, KEPT FOR YOU")
                    }

                    if entitlements.hasPlus {
                        Text("WITNESS+ IS ACTIVE ON THIS DEVICE")
                            .font(AtlasType.technical(11, weight: .bold)).tracking(1)
                            .foregroundStyle(AtlasTheme.sepia)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                    } else if entitlements.packages.isEmpty {
                        Text("WITNESS+ IS NOT AVAILABLE YET")
                            .font(AtlasType.technical(11, weight: .bold)).tracking(1)
                            .foregroundStyle(AtlasTheme.inkMuted)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                    } else {
                        VStack(spacing: 10) {
                            ForEach(entitlements.packages, id: \.identifier) { package in
                                Button {
                                    Task { await entitlements.purchase(package) }
                                } label: {
                                    HStack {
                                        Text(packageTitle(package))
                                            .font(AtlasType.technical(11, weight: .bold)).tracking(1)
                                        Spacer()
                                        Text(package.storeProduct.localizedPriceString)
                                            .font(AtlasType.technical(11, weight: .bold)).tracking(0.5)
                                    }
                                    .foregroundStyle(AtlasTheme.paper)
                                    .padding(.horizontal, 16).frame(maxWidth: .infinity, minHeight: 52)
                                    .background(AtlasTheme.ink)
                                }
                                .buttonStyle(.plain)
                                .disabled(entitlements.isWorking)
                            }
                        }
                    }

                    Button("RESTORE PURCHASES") {
                        Task { await entitlements.restore() }
                    }
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1)
                    .foregroundStyle(AtlasTheme.sepia)
                    .frame(minHeight: 44)
                    .disabled(entitlements.isWorking)

                    if let error = entitlements.lastError {
                        Text(error)
                            .font(.footnote).foregroundStyle(AtlasTheme.inkMuted)
                    }

                    Text("Subscriptions renew automatically until canceled in your App Store settings. Witness+ funds the making of new plates; it does not buy conservation outcomes.")
                        .font(.footnote).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(3)
                }
                .padding(22).foregroundStyle(AtlasTheme.ink)
            }
            .background(AtlasPaper().ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("CLOSE") { dismiss() }.font(AtlasType.technical(10, weight: .bold))
                }
            }
        }
        .task {
            await entitlements.refreshOfferings()
            let sync = WitnessSync.shared
            Task.detached { await sync.logEvent("paywall_shown") }
        }
    }

    private func packageTitle(_ package: Package) -> String {
        switch package.packageType {
        case .annual: "ONE YEAR"
        case .monthly: "ONE MONTH"
        default: package.storeProduct.localizedTitle.uppercased()
        }
    }

    private func promiseRow(_ text: String) -> some View {
        HStack {
            Text(text).font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
            Spacer()
            Text("·").foregroundStyle(AtlasTheme.sepia)
        }
        .frame(minHeight: 44)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }
}
