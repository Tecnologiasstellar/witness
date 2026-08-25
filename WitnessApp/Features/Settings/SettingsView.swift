import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var entitlements = PlusEntitlements.shared
    @ObservedObject private var reminders = ReminderService.shared
    @State private var isPaywallPresented = false
    @State private var reminderTime = Calendar.current.date(from: DateComponents(hour: 8)) ?? .now

    private static let privacyURL = URL(string: "https://witness-rho.vercel.app/privacy")!
    private static let termsURL = URL(string: "https://witness-rho.vercel.app/terms")!
    private static let supportEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20support")!
    private static let correctionsEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20correction")!

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("INDEX")
                        .font(AtlasType.display(34, weight: .semibold))
                    witnessPlusSection
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
            .sheet(isPresented: $isPaywallPresented) { WitnessPlusPaywall() }
            .onAppear {
                reminderTime = Calendar.current.date(
                    from: DateComponents(hour: reminders.hour, minute: reminders.minute)
                ) ?? .now
            }
            .task { await reminders.refreshAuthorization() }
        }
    }

    private var witnessPlusSection: some View {
        section("WITNESS+") {
            actionRow(entitlements.hasPlus ? "WITNESS+ · ACTIVE" : "THE COMPLETE CABINET") { isPaywallPresented = true }
            actionRow("RESTORE PURCHASES") { Task { await entitlements.restore() } }
        }
    }

    private var remindersSection: some View {
        section("REMINDERS") {
            HStack {
                Text("DAILY REMINDER")
                    .font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
                Spacer()
                Toggle("Daily reminder", isOn: Binding(
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
