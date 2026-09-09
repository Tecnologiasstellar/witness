import SwiftUI
import WitnessCore

/// INDEX — the introduction first, then THE WORKS as three plate-led cards
/// (Field Season, the Atlas, Support), REMINDERS, and one ABOUT page that
/// holds the credits and the correction line. Facts only — never a tier grid.
struct SettingsView: View {
    @ObservedObject var commerce: CommerceModel
    var weeklyPlate: String? = nil
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var reminders = ReminderService.shared
    @State private var reminderTime = Calendar.current.date(from: DateComponents(hour: 8)) ?? .now

    private static let privacyURL = URL(string: "https://witnessatlas.com/privacy")!
    private static let termsURL = URL(string: "https://witnessatlas.com/terms")!

    private let edition = FieldSeasonLoader.bundled

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("INDEX")
                        .font(AtlasType.display(36, weight: .semibold))
                    howItWorksRow
                    worksSection
                    remindersSection
                    aboutRow
                    footer
                }
                .padding(22).foregroundStyle(AtlasTheme.ink)
            }
            .background(AtlasPaper().ignoresSafeArea())
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("CLOSE") { dismiss() }.font(AtlasType.technical(12, weight: .bold)) } }
            .onAppear {
                reminderTime = Calendar.current.date(
                    from: DateComponents(hour: reminders.hour, minute: reminders.minute)
                ) ?? .now
            }
            .task { await reminders.refreshAuthorization() }
            .task { await commerce.startIfNeeded() }
        }
    }

    // MARK: - How Witness works

    /// The introduction, readable again (D-026) — first thing on the page,
    /// pushed inside this stack without the reminder page.
    private var howItWorksRow: some View {
        NavigationLink {
            OnboardingView(mode: .review, weeklyPlate: weeklyPlate ?? "vaquita-plate-01")
        } label: {
            HStack(spacing: 14) {
                thumbnail(weeklyPlate ?? "vaquita-plate-01", width: 44, height: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text("HOW WITNESS WORKS")
                        .font(AtlasType.technical(14, weight: .bold)).tracking(0.9)
                    Text("Five pages · the weekly plate, bearing witness, the acts")
                        .font(AtlasType.technical(12, weight: .medium))
                        .foregroundStyle(AtlasTheme.sepia)
                }
                Spacer()
                Text("›").font(AtlasType.display(22)).foregroundStyle(AtlasTheme.sepia)
            }
            .foregroundStyle(AtlasTheme.ink)
            .padding(14)
            .background(AtlasTheme.paperFresh)
            .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("index.howItWorks")
    }

    // MARK: - The works

    /// The Access overview (D-020, §9.2): the standing free promise, then the
    /// three works as plates you can walk into. Owned and unowned works render
    /// alike — the word carries the state.
    private var worksSection: some View {
        section("THE WORKS") {
            staticRow("WITNESS · FREE", detail: "Every Monday")
                .accessibilityIdentifier("access.overview.free")
                .padding(.bottom, 18)

            VStack(spacing: 18) {
                NavigationLink {
                    FieldSeasonPreviewView(commerce: commerce)
                } label: {
                    workCard(title: "FIELD SEASON", detail: fieldSeasonDetail, line: "A finite, authored edition, read and narrated. Yours to keep.") {
                        plateHero(fieldSeasonPlate)
                    }
                }
                .buttonStyle(AtlasPressStyle())
                .accessibilityIdentifier("access.overview.fieldseason")

                NavigationLink {
                    AtlasAccessSheet(commerce: commerce)
                } label: {
                    workCard(title: "THE ATLAS", detail: commerce.atlasStatusLine, line: "The living library. Every plate, growing weekly.") {
                        PlateCollageStrip(height: 124, spacing: -30)
                            .padding(.bottom, 20)
                            .frame(height: 176)
                            .clipped()
                    }
                }
                .buttonStyle(AtlasPressStyle())
                .accessibilityIdentifier("access.overview.atlas")

                NavigationLink {
                    SupportWitnessView(commerce: commerce)
                } label: {
                    workCard(title: "SUPPORT WITNESS", detail: "One-time tip", line: "Made by one person. A tip funds the making.") {
                        PlateCollageStrip(
                            assets: ["vaquita-detail-01", "amur-leopard-detail-01", "whooping-crane-detail-01"],
                            height: 124, spacing: -30
                        )
                        .padding(.bottom, 20)
                        .frame(height: 176)
                        .clipped()
                    }
                }
                .buttonStyle(AtlasPressStyle())
                .accessibilityIdentifier("access.overview.support")
            }
            .padding(.bottom, 18)

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

            PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)
                .padding(.top, 12)

            if let verifiedLine = commerce.accessVerifiedLine {
                Text(verifiedLine)
                    .font(AtlasType.technical(11, weight: .medium))
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .padding(.top, 8)
                    .accessibilityIdentifier("access.overview.verified")
            }
        }
    }

    private var fieldSeasonPlate: String {
        edition?.chapters.first { $0.resolvedKind == .chapter }?.heroAssetID ?? "vaquita-plate-01"
    }

    private var fieldSeasonDetail: String {
        if commerce.ownsFieldSeason { return "Owned" }
        if commerce.atlasIsActive { return "Included" }
        let stories = edition?.chapters.filter { $0.resolvedKind == .chapter }.count ?? 0
        return stories > 0 ? "\(stories) stories" : "Preview"
    }

    /// A work as a plate first: the art on top, the name and its real state
    /// beneath, one line of what it is. No price on the card — the page has it.
    private func workCard(title: String, detail: String?, line: String, @ViewBuilder art: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            art()
                .frame(maxWidth: .infinity)
                .background(AtlasTheme.paperAged)
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(title)
                        .font(AtlasType.display(24, weight: .semibold))
                    Spacer()
                    if let detail {
                        Text(detail)
                            .font(AtlasType.technical(12, weight: .bold)).tracking(0.8)
                            .foregroundStyle(AtlasTheme.sepia)
                    }
                    Text("›").font(AtlasType.display(22)).foregroundStyle(AtlasTheme.sepia)
                }
                Text(line)
                    .font(AtlasType.display(16, weight: .regular, italic: true))
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            .padding(14)
        }
        .foregroundStyle(AtlasTheme.ink)
        .background(AtlasTheme.paperFresh)
        .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(detail.map { "\(title), \($0)" } ?? title)
    }

    private func plateHero(_ asset: String) -> some View {
        Group {
            if let art = UIImage(named: asset) {
                Image(uiImage: art)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(height: 176)
        .frame(maxWidth: .infinity)
        .clipped()
        .accessibilityHidden(true)
    }

    // MARK: - Reminders

    private var remindersSection: some View {
        section("REMINDERS") {
            HStack {
                Text("WEEKLY REMINDER")
                    .font(AtlasType.technical(13, weight: .medium)).tracking(0.7)
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
            .frame(minHeight: 48)
            .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }

            if reminders.isEnabled {
                HStack {
                    Text("TIME")
                        .font(AtlasType.technical(13, weight: .medium)).tracking(0.7)
                    Spacer()
                    DatePicker("Reminder time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: reminderTime) { _, newValue in
                            let parts = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                            Task { await reminders.enable(hour: parts.hour ?? 8, minute: parts.minute ?? 0) }
                        }
                }
                .frame(minHeight: 48)
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
                            .font(AtlasType.technical(12, weight: .medium)).tracking(0.6)
                            .foregroundStyle(AtlasTheme.sepia)
                        Spacer()
                        Text("·").foregroundStyle(AtlasTheme.sepia)
                    }
                    .frame(minHeight: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
            }
        }
    }

    // MARK: - About

    private var aboutRow: some View {
        NavigationLink {
            IndexAboutView()
        } label: {
            navigationRowLabel(title: "ABOUT WITNESS", detail: "Sources · credits · corrections")
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("index.about")
    }

    private var footer: some View {
        HStack(spacing: 16) {
            Link("PRIVACY POLICY", destination: Self.privacyURL)
                .foregroundStyle(AtlasTheme.sepia)
            Link("TERMS OF USE", destination: Self.termsURL)
                .foregroundStyle(AtlasTheme.sepia)
            Spacer()
            Text("WITNESS · \(Self.versionLabel)")
                .foregroundStyle(AtlasTheme.inkMuted)
        }
        .font(AtlasType.technical(11, weight: .medium))
        .tracking(1.0)
        .frame(minHeight: 44)
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
            Text(title).font(AtlasType.technical(12, weight: .bold)).tracking(1.3).foregroundStyle(AtlasTheme.sepia).padding(.bottom, 10)
            rows()
        }
    }

    @ViewBuilder
    private func thumbnail(_ asset: String?, width: CGFloat = 34, height: CGFloat = 44) -> some View {
        // A sliver of the actual work behind the row — the pieces stay
        // visible from the menu without a word of selling.
        if let asset, let art = UIImage(named: asset) {
            Image(uiImage: art)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipped()
                .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                .accessibilityHidden(true)
        }
    }

    private func navigationRowLabel(title: String, detail: String?, thumb: String? = nil) -> some View {
        HStack(spacing: 12) {
            thumbnail(thumb)
            Text(title).font(AtlasType.technical(13, weight: .medium)).tracking(0.7)
            Spacer()
            if let detail {
                Text(detail).font(AtlasType.technical(12, weight: .medium)).foregroundStyle(AtlasTheme.sepia)
            }
            Text("›").foregroundStyle(AtlasTheme.sepia)
        }
        .foregroundStyle(AtlasTheme.ink)
        .frame(minHeight: 48)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }

    private func staticRow(_ label: String, detail: String? = nil, thumb: String? = nil) -> some View {
        HStack(spacing: 12) {
            thumbnail(thumb)
            Text(label).font(AtlasType.technical(13, weight: .medium)).tracking(0.7)
            Spacer()
            if let detail {
                Text(detail)
                    .font(AtlasType.technical(12, weight: .medium))
                    .foregroundStyle(AtlasTheme.sepia)
                    .multilineTextAlignment(.trailing)
            }
            Text("·").foregroundStyle(AtlasTheme.sepia)
        }
        .frame(minHeight: 48)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - About page

/// The credits that keep the record honest, and the two ways to write in.
/// One pushed page so the INDEX itself stays a menu.
private struct IndexAboutView: View {
    private static let supportEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20support")!
    private static let correctionsEmailURL = URL(string: "mailto:albertovillalpando@gmail.com?subject=Witness%20correction")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("ABOUT WITNESS")
                    .font(AtlasType.display(30, weight: .semibold))
                    .padding(.bottom, 12)
                Text("Made by one person. No account, and your notes stay on this device.")
                    .font(AtlasType.display(17, weight: .regular))
                    .lineSpacing(5)
                    .padding(.bottom, 24)
                    .accessibilityIdentifier("index.about.statement")

                creditRow("SOURCES", "Cited on every card")
                creditRow("ILLUSTRATION", "AI-assisted, accuracy-reviewed")
                creditRow("NARRATION", "Synthetic voice, disclosed in each chapter")
                linkRow("REPORT A CORRECTION", url: Self.correctionsEmailURL)
                linkRow("WRITE TO THE MAKER", url: Self.supportEmailURL)
            }
            .padding(22)
            .foregroundStyle(AtlasTheme.ink)
        }
        .background(AtlasPaper().ignoresSafeArea())
    }

    private func creditRow(_ label: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(AtlasType.technical(13, weight: .medium)).tracking(0.7)
            Text(detail).font(AtlasType.technical(12, weight: .medium)).foregroundStyle(AtlasTheme.sepia)
        }
        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityElement(children: .combine)
    }

    private func linkRow(_ label: String, url: URL) -> some View {
        Link(destination: url) {
            HStack {
                Text(label).font(AtlasType.technical(13, weight: .medium)).tracking(0.7)
                Spacer()
                AtlasIconView(icon: .returnMark, size: 14, color: AtlasTheme.sepia)
            }
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }
}
