import SwiftUI
import WitnessCore

/// INDEX — three groups and a footer, read like a book's front and back
/// matter: THE WORKS (the free ritual beside the two editions and the tip),
/// REMINDERS, and a COLOPHON that says who makes Witness, what the works
/// fund, and how the record is kept. Facts only — never a tier grid.
struct SettingsView: View {
    @ObservedObject var commerce: CommerceModel
    var weeklyPlate: String? = nil
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var reminders = ReminderService.shared
    @State private var reminderTime = Calendar.current.date(from: DateComponents(hour: 8)) ?? .now

    private static let privacyURL = URL(string: "https://witnessatlas.com/privacy")!
    private static let termsURL = URL(string: "https://witnessatlas.com/terms")!
    private static let supportEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20support")!
    private static let correctionsEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20correction")!

    private let edition = FieldSeasonLoader.loadBundledEdition()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("INDEX")
                        .font(AtlasType.display(34, weight: .semibold))
                    worksSection
                    remindersSection
                    colophonSection
                    footer
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

    // MARK: - The works

    /// The Access overview (D-020, §9.2): the standing free promise, the two
    /// works with their real state, restore, manage, and the quiet Support
    /// row. Owned and unowned works render alike — the word carries the state.
    private var worksSection: some View {
        section("THE WORKS") {
            staticRow("WITNESS · FREE", thumb: weeklyPlate)
                .accessibilityIdentifier("access.overview.free")

            NavigationLink {
                FieldSeasonPreviewView(commerce: commerce)
            } label: {
                navigationRowLabel(title: "FIELD SEASON", detail: fieldSeasonDetail, thumb: "vaquita-plate-01")
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.overview.fieldseason")

            NavigationLink {
                AtlasAccessSheet(commerce: commerce)
            } label: {
                navigationRowLabel(title: "ATLAS", detail: commerce.atlasStatusLine, thumb: "snow-leopard-plate-01")
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
                navigationRowLabel(title: "SUPPORT WITNESS", detail: "One-time tip")
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

    private var fieldSeasonDetail: String {
        if commerce.ownsFieldSeason { return "Owned" }
        if commerce.atlasIsActive { return "Included" }
        let stories = edition?.chapters.filter { $0.resolvedKind == .chapter }.count ?? 0
        return stories > 0 ? "\(stories) stories" : "Preview"
    }

    // MARK: - Reminders

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

    // MARK: - Colophon

    /// Who makes Witness, what the works fund (the §5.3 line, said in full
    /// exactly once in the app), and the credits that keep the record honest.
    private var colophonSection: some View {
        section("COLOPHON") {
            Text("Witness is made by one person. It asks for no account, and your notes stay on this device. Field Season and the Atlas support research, fact-checking, illustration, narration, accessibility, and operation of the app. Your Witness remains free.")
                .font(AtlasType.display(16, weight: .regular))
                .lineSpacing(5)
                .padding(.bottom, 6)
                .accessibilityIdentifier("index.colophon.statement")
            Text("— Alberto, who makes Witness")
                .font(AtlasType.display(14, weight: .regular, italic: true))
                .foregroundStyle(AtlasTheme.sepia)
                .padding(.bottom, 14)

            staticRow("SOURCES", detail: "Cited on every card")
            staticRow("ILLUSTRATION", detail: "AI-assisted, accuracy-reviewed")
            staticRow("NARRATION", detail: "Synthetic voice, disclosed in each chapter")
            linkRow("REPORT A CORRECTION", url: Self.correctionsEmailURL)
            linkRow("WRITE TO THE MAKER", url: Self.supportEmailURL)
        }
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Witness does not turn attention, shares, or self-reported actions into conservation outcomes.")
                .font(.footnote).foregroundStyle(AtlasTheme.inkMuted).lineSpacing(3)
            HStack(spacing: 16) {
                Link("PRIVACY POLICY", destination: Self.privacyURL)
                    .foregroundStyle(AtlasTheme.sepia)
                Link("TERMS OF USE", destination: Self.termsURL)
                    .foregroundStyle(AtlasTheme.sepia)
                Spacer()
                Text("WITNESS · \(Self.versionLabel)")
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            .font(AtlasType.technical(10, weight: .medium))
            .tracking(1.0)
            .frame(minHeight: 44)
        }
        .padding(.top, 4)
    }

    private static var versionLabel: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "0"
        let build = info?["CFBundleVersion"] as? String ?? "0"
        return "\(version) (\(build))"
    }

    // MARK: - Row anatomy

    private func section(_ title: String, @ViewBuilder rows: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(AtlasType.technical(10, weight: .bold)).tracking(1.2).foregroundStyle(AtlasTheme.sepia).padding(.bottom, 8)
            rows()
        }
    }

    @ViewBuilder
    private func thumbnail(_ asset: String?) -> some View {
        // A sliver of the actual work behind the row — the pieces stay
        // visible from the menu without a word of selling.
        if let asset, let art = UIImage(named: asset) {
            Image(uiImage: art)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 38)
                .clipped()
                .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                .accessibilityHidden(true)
        }
    }

    private func navigationRowLabel(title: String, detail: String?, thumb: String? = nil) -> some View {
        HStack(spacing: 12) {
            thumbnail(thumb)
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

    private func staticRow(_ label: String, detail: String? = nil, thumb: String? = nil) -> some View {
        HStack(spacing: 12) {
            thumbnail(thumb)
            Text(label).font(AtlasType.technical(11, weight: .medium)).tracking(0.7)
            Spacer()
            if let detail {
                Text(detail)
                    .font(AtlasType.technical(11, weight: .medium))
                    .foregroundStyle(AtlasTheme.sepia)
                    .multilineTextAlignment(.trailing)
            }
            Text("·").foregroundStyle(AtlasTheme.sepia)
        }
        .frame(minHeight: 44)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityElement(children: .combine)
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
