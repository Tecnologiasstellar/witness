import SwiftUI

struct SettingsView: View {
    @ObservedObject var commerce: CommerceModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var reminders = ReminderService.shared
    @State private var reminderTime = Calendar.current.date(from: DateComponents(hour: 8)) ?? .now

    private static let privacyURL = URL(string: "https://witnessatlas.com/privacy")!
    private static let termsURL = URL(string: "https://witnessatlas.com/terms")!
    private static let supportEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20support")!
    private static let correctionsEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20correction")!

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("INDEX")
                        .font(AtlasType.display(34, weight: .semibold))
                    accessSection
                    remindersSection
                    privacySection
                    contentSection
                    supportSection
                    Text("Witness does not turn attention, shares, or self-reported actions into conservation outcomes.")
                        .font(.footnote).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(3)
                }
                .padding(22).foregroundStyle(AtlasTheme.ink)
            }
            .background(AtlasPaper().ignoresSafeArea())
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("CLOSE") { dismiss() }.font(AtlasType.technical(10, weight: .bold)) } }
            .onAppear {
                reminderTime = Calendar.current.date(
                    from: DateComponents(hour: reminders.hour, minute: reminders.minute)
                ) ?? .now
            }
            .task { await reminders.refreshAuthorization() }
            .task { await commerce.startIfNeeded() }
        }
    }

    /// The Access overview (D-020): current standing, the two deeper works,
    /// restore, manage, and the quiet Support row. Facts only — never a tier
    /// grid, provider terminology, or raw entitlement identifiers.
    private var accessSection: some View {
        section("ACCESS") {
            staticRow("WITNESS · FREE")
                .accessibilityIdentifier("access.overview.free")

            NavigationLink {
                FieldSeasonPreviewView(commerce: commerce)
            } label: {
                navigationRowLabel(
                    title: "FIELD SEASON",
                    detail: commerce.ownsFieldSeason ? "Owned" : "View"
                )
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.overview.fieldseason")

            NavigationLink {
                AtlasAccessSheet(commerce: commerce)
            } label: {
                navigationRowLabel(title: "ATLAS", detail: commerce.atlasStatusLine)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.overview.atlas")

            AccessQuietRow(
                title: "RESTORE PURCHASES",
                detail: commerce.restorePhase == .restoring ? "…" : nil,
                identifier: "access.overview.restore"
            ) {
                Task { await commerce.restore() }
            }

            if commerce.atlasIsActive {
                ManageSubscriptionRow(identifier: "access.overview.manage")
            }

            NavigationLink {
                SupportWitnessView(commerce: commerce)
            } label: {
                navigationRowLabel(title: "SUPPORT WITNESS", detail: nil)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.overview.support")

            PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)
                .padding(.top, 12)

            if let verifiedLine = commerce.accessVerifiedLine {
                Text(verifiedLine)
                    .font(AtlasType.technical(9, weight: .medium))
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .padding(.top, 8)
                    .accessibilityIdentifier("access.overview.verified")
            }
        }
    }

    private func navigationRowLabel(title: String, detail: String?) -> some View {
        HStack {
            Text(title).font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
            Spacer()
            if let detail {
                Text(detail).font(AtlasType.technical(11, weight: .medium)).foregroundStyle(AtlasTheme.sepia)
            }
            Text("›").foregroundStyle(AtlasTheme.sepia)
        }
        .foregroundStyle(AtlasTheme.ink)
        .frame(minHeight: 44)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }

    private var remindersSection: some View {
        section("REMINDERS") {
            HStack {
                Text("WEEKLY REMINDER")
                    .font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
                Spacer()
                Toggle("Weekly reminder", isOn: Binding(
                    get: { reminders.isEnabled },
                    set: { on in
                        if on {
                            let parts = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
                            Task { await reminders.enable(hour: parts.hour ?? 8, minute: parts.minute ?? 0) }
                        } else {
                            reminders.disable()
                        }
                    }
                ))
                .labelsHidden()
                .tint(AtlasTheme.accentSage)
                .accessibilityIdentifier("index.reminderToggle")
            }
            .frame(minHeight: 44)
            .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }

            if reminders.isEnabled {
                HStack {
                    Text("TIME")
                        .font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
                    Spacer()
                    DatePicker("Reminder time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: reminderTime) { _, newValue in
                            let parts = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                            Task { await reminders.enable(hour: parts.hour ?? 8, minute: parts.minute ?? 0) }
                        }
                }
                .frame(minHeight: 44)
                .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
            }

            if reminders.isSystemDenied {
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text("NOTIFICATIONS ARE OFF · OPEN SYSTEM SETTINGS")
                            .font(AtlasType.technical(10, weight: .medium)).tracking(0.6)
                            .foregroundStyle(AtlasTheme.sepia)
                        Spacer()
                        Text("·").foregroundStyle(AtlasTheme.sepia)
                    }
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
            }
        }
    }

    private var privacySection: some View {
        section("PRIVACY") {
            staticRow("NO ACCOUNT · NO PERSONAL DATA")
            staticRow("REFLECTIONS STAY ON THIS DEVICE")
            linkRow("PRIVACY POLICY", url: Self.privacyURL)
            linkRow("TERMS OF USE", url: Self.termsURL)
        }
    }

    private var contentSection: some View {
        section("CONTENT") {
            staticRow("ILLUSTRATIONS ARE AI-ASSISTED, ACCURACY-REVIEWED")
            staticRow("EVERY FACT MAPS TO A CITED SOURCE")
            linkRow("REPORT A CORRECTION", url: Self.correctionsEmailURL)
        }
    }

    private var supportSection: some View {
        section("SUPPORT") {
            linkRow("CONTACT", url: Self.supportEmailURL)
            staticRow("WITNESS · \(Self.versionLabel)")
        }
    }

    private static var versionLabel: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "0"
        let build = info?["CFBundleVersion"] as? String ?? "0"
        return "\(version) (\(build))"
    }

    private func section(_ title: String, @ViewBuilder rows: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(AtlasType.technical(10, weight: .bold)).tracking(1.2).foregroundStyle(AtlasTheme.sepia).padding(.bottom, 8)
            rows()
        }
    }

    private func staticRow(_ label: String) -> some View {
        HStack { Text(label).font(AtlasType.technical(11, weight: .medium)).tracking(0.7); Spacer(); Text("·").foregroundStyle(AtlasTheme.sepia) }
            .frame(minHeight: 44)
            .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }

    private func actionRow(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(label).font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
                Spacer()
                Text("·").foregroundStyle(AtlasTheme.sepia)
            }
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }

    private func linkRow(_ label: String, url: URL) -> some View {
        Link(destination: url) {
            HStack {
                Text(label).font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
                Spacer()
                AtlasIconView(icon: .returnMark, size: 13, color: AtlasTheme.sepia)
            }
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }
}
