import SwiftUI
import WitnessCore

/// The first-run introduction (D-026): six skippable pages, one idea each,
/// then the card. Nothing is asked here — no account, no price, no iOS
/// prompt. The reminder page records a preferred time only; the
/// post-witness primer turns it into a real reminder (D-008). The same
/// pages read again from INDEX in review mode, without the reminder page.
struct OnboardingView: View {
    enum Mode { case firstRun, review }

    struct Outcome {
        let pagesSeen: Int
        let skipped: Bool
        /// morning | midday | evening | later
        let reminder: String
    }

    let mode: Mode
    let weeklyPlate: String
    var weeklyName: String? = nil
    var onFinish: (Outcome) -> Void = { _ in }

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ObservedObject private var reminders = ReminderService.shared
    @State private var page: Page = .welcome
    @State private var furthestIndex = 0
    @State private var reminderChoice = "later"

    private let edition = FieldSeasonLoader.loadBundledEdition()

    private enum Page: String, CaseIterable {
        case welcome, weekly, witness, acts, reminder, works
    }

    private static let atlasAssets = ["gharial-plate-01", "snow-leopard-plate-01", "whooping-crane-plate-01"]

    private var pages: [Page] {
        mode == .review ? Page.allCases.filter { $0 != .reminder } : Page.allCases
    }

    private var storyCount: Int {
        edition?.chapters.filter { $0.resolvedKind == .chapter }.count ?? 8
    }

    private var fieldSeasonPlate: String {
        edition?.chapters.first { $0.resolvedKind == .chapter }?.heroAssetID ?? "vaquita-plate-01"
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    ForEach(pages, id: \.self) { page in
                        // Paged content re-applies the safe area per page,
                        // so each page ignores it itself and lays out from
                        // the measured inset instead.
                        pageView(page, topInset: geo.safeAreaInsets.top)
                            .ignoresSafeArea(edges: .top)
                            .tag(page)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(edges: .top)
                .onChange(of: page) { _, current in
                    furthestIndex = max(furthestIndex, pages.firstIndex(of: current) ?? 0)
                }
                bottomBar
            }
            .overlay(alignment: .topTrailing) {
                if mode == .firstRun { skipButton }
            }
        }
        .background(AtlasPaper())
        .foregroundStyle(AtlasTheme.ink)
        .toolbarBackground(.hidden, for: .navigationBar)
        .tint(AtlasTheme.sepia)
    }

    // MARK: - Pages

    @ViewBuilder
    private func pageView(_ page: Page, topInset: CGFloat) -> some View {
        switch page {
        case .welcome:
            welcomePage(topInset: topInset)
        case .weekly:
            platePage(.weekly, topInset: topInset) {
                AtlasIconView(icon: .dusk, size: 26, color: AtlasTheme.sepia)
                eyebrow("ONE SPECIES A WEEK")
                headline("Every Monday, one plate arrives.")
                numbered("01", "A new species, drawn and told in full.")
                numbered("02", "Its story, its sources, and the living count of everyone witnessing it.")
                numbered("03", "The weekly card is free, and stays free.")
                if !dynamicTypeSize.isAccessibilitySize {
                    // Past weeks' plates, so "arrives" is something you can see.
                    PlateCollageStrip(height: 104)
                        .padding(.top, 18)
                }
            }
        case .witness:
            platePage(.witness, topInset: topInset) {
                AtlasIconView(icon: .fieldMark, size: 26, color: AtlasTheme.sepia)
                eyebrow("BEAR WITNESS")
                headline("One deliberate tap, once a week.")
                passage("To witness is to give a species one minute of your full attention. You join an anonymous count of everyone who witnessed alongside you.")
                passage("No account. Your notes stay on this device.")
                emblem(.fieldMark)
            }
        case .acts:
            platePage(.acts, topInset: topInset) {
                AtlasIconView(icon: .nib, size: 26, color: AtlasTheme.sepia)
                eyebrow("THE ACTS")
                headline("Every species comes with one real door.")
                passage("One vetted act per species — a real organization, already doing the work. Take it up, and it leaves a line in your field journal.")
                emblem(.nib)
            }
        case .reminder:
            reminderPage(topInset: topInset)
        case .works:
            worksPage(topInset: topInset)
        }
    }

    private static let welcomeHeadline = "Some species disappear before most of us learn their names."
    private static let welcomeSupport = "Witness gives one of them your attention each week — and one honest way to act."

    private func welcomePage(topInset: CGFloat) -> some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                // Large type: the plate sits above the words on paper so
                // nothing has to fit inside a scrim.
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        plateImage(height: 280)
                        eyebrow("WITNESS")
                        headline(Self.welcomeHeadline, size: 30)
                            .accessibilityIdentifier("onboarding.welcome.headline")
                        passage(Self.welcomeSupport)
                            .accessibilityIdentifier("onboarding.welcome.support")
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, topInset + 56)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            } else {
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        plateImage(width: geo.size.width, height: geo.size.height)
                        LinearGradient(
                            colors: [AtlasTheme.heroScrim.opacity(0.55), .clear],
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 140)
                        .frame(maxHeight: .infinity, alignment: .top)
                        // The same scrim as the weekly hero, so the first
                        // words of the app already look like the card.
                        LinearGradient(
                            colors: [AtlasTheme.heroScrim.opacity(0.95), AtlasTheme.heroScrim.opacity(0.55), .clear],
                            startPoint: .bottom, endPoint: .top
                        )
                        .frame(height: 300)
                        VStack(alignment: .leading, spacing: 12) {
                            eyebrow("WITNESS", color: AtlasTheme.heroInk.opacity(0.85))
                            headline(Self.welcomeHeadline, size: 30)
                                .accessibilityIdentifier("onboarding.welcome.headline")
                            passage(Self.welcomeSupport)
                                .opacity(0.92)
                                .accessibilityIdentifier("onboarding.welcome.support")
                        }
                        .foregroundStyle(AtlasTheme.heroInk)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("onboarding.page.welcome")
    }

    private func reminderPage(topInset: CGFloat) -> some View {
        platePage(.reminder, topInset: topInset) {
            eyebrow("A WEEKLY REMINDER")
            headline("Would you like each week’s species to find you?")
            passage("One note on Monday, when the new plate arrives. Nothing else.")
            VStack(spacing: 10) {
                ForEach(ReminderService.presets, id: \.label) { preset in
                    let time = Self.timeLabel(hour: preset.hour, minute: preset.minute)
                    Button {
                        choose(preset)
                    } label: {
                        HStack {
                            Text(preset.label)
                                .font(AtlasType.technical(11, weight: .bold)).tracking(1.1)
                            Spacer()
                            Text(time)
                                .font(AtlasType.display(15))
                                .foregroundStyle(AtlasTheme.inkMuted)
                        }
                        .foregroundStyle(AtlasTheme.ink)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(AtlasPressStyle())
                    .accessibilityIdentifier("onboarding.reminder.\(preset.label.lowercased())")
                    .accessibilityLabel("\(preset.label.capitalized), \(time)")
                }
            }
            .padding(.top, 6)
            Text("iOS will ask for permission after your first Witness — not before.")
                .font(AtlasType.technical(10, weight: .medium))
                .foregroundStyle(AtlasTheme.inkMuted)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func worksPage(topInset: CGFloat) -> some View {
        platePage(.works, topInset: topInset) {
            eyebrow("THE WORKS")
            headline("Two finished works stand behind the weekly card.")
            workRow(title: "Field Season One", note: "\(storyCount) stories, told in full.") {
                flatPlate(fieldSeasonPlate)
            }
            workRow(title: "The Atlas", note: "The living library, growing weekly.") {
                if dynamicTypeSize.isAccessibilitySize {
                    flatPlate("snow-leopard-plate-01")
                } else {
                    PlateCollageStrip(assets: Self.atlasAssets, height: 58, spacing: -28)
                        .frame(width: 100)
                }
            }
            HStack(alignment: .center, spacing: 14) {
                AtlasIconView(icon: .contents, size: 18, color: AtlasTheme.heroInk)
                    .frame(width: 44, height: 44)
                    .background(AtlasTheme.heroScrim.opacity(0.92))
                    .accessibilityHidden(true)
                Text("Both live behind the Index mark, at the top-left of every card.")
                    .font(AtlasType.display(15))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 4)
            Text("Your Witness remains free.")
                .font(AtlasType.display(15, weight: .regular, italic: true))
                .foregroundStyle(AtlasTheme.inkMuted)
                .accessibilityIdentifier("onboarding.works.free")
        }
    }

    // MARK: - Page anatomy

    private func platePage<Content: View>(
        _ page: Page,
        topInset: CGFloat,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack {
            // The frame clears the SKIP row; at accessibility sizes the
            // text scrolls past where the frame would sit, so it is dropped.
            if !dynamicTypeSize.isAccessibilitySize {
                PlateFrame(topMargin: topInset + 44, bottomMargin: 20)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    content()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 44)
                .padding(.top, topInset + 44 + 36)
                .padding(.bottom, 48)
            }
            .scrollIndicators(.hidden)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("onboarding.page.\(page.rawValue)")
    }

    private func eyebrow(_ text: String, color: Color = AtlasTheme.sepia) -> some View {
        Text(text)
            .font(AtlasType.technical(10, weight: .bold)).tracking(1.25)
            .foregroundStyle(color)
            .accessibilityIdentifier("onboarding.eyebrow." + text.lowercased().replacingOccurrences(of: " ", with: "-"))
    }

    private func headline(_ text: String, size: CGFloat = 28) -> some View {
        Text(text)
            .font(AtlasType.display(size, weight: .semibold))
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityAddTraits(.isHeader)
    }

    private func passage(_ text: String) -> some View {
        Text(text)
            .font(AtlasType.display(17))
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
    }

    /// The page's mark drawn large and faint in the plate's lower field —
    /// an engraver's device, not a second illustration.
    private func emblem(_ icon: AtlasIcon) -> some View {
        AtlasIconView(icon: icon, size: 120, lineWidth: 0.9, color: AtlasTheme.sepia.opacity(0.42))
            .frame(maxWidth: .infinity)
            .padding(.top, 36)
    }

    private func numbered(_ number: String, _ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(number)
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                .foregroundStyle(AtlasTheme.sepia)
                .fixedSize()
                .frame(minWidth: 24, alignment: .leading)
                .accessibilityIdentifier("onboarding.numeral.\(number)")
            passage(text)
        }
    }

    private func workRow<Visual: View>(title: String, note: String, @ViewBuilder visual: () -> Visual) -> some View {
        HStack(alignment: .center, spacing: 14) {
            visual()
                .frame(width: 100, alignment: .center)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AtlasType.display(17, weight: .medium))
                Text(note)
                    .font(AtlasType.display(14, weight: .regular, italic: true))
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func flatPlate(_ asset: String) -> some View {
        if let image = UIImage(named: asset) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 58, height: 74)
                .clipped()
                .padding(3)
                .background(AtlasTheme.paperFresh)
                .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
        }
    }

    @ViewBuilder
    private func plateImage(width: CGFloat? = nil, height: CGFloat) -> some View {
        if let image = UIImage(named: weeklyPlate) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(width: width, height: height)
                .clipped()
                .accessibilityLabel(weeklyName.map { "Illustrated plate of the \($0)" } ?? "Illustrated plate of this week’s species")
        } else {
            AtlasTheme.paperAged
                .frame(maxWidth: .infinity)
                .frame(width: width, height: height)
        }
    }

    // MARK: - Chrome

    private var skipButton: some View {
        Button {
            finish(skipped: true)
        } label: {
            Text("SKIP")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.2)
                .foregroundStyle(page == .welcome && !dynamicTypeSize.isAccessibilitySize ? AtlasTheme.heroInk : AtlasTheme.sepia)
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.trailing, 12)
        .accessibilityIdentifier("onboarding.skip")
        .accessibilityLabel("Skip introduction")
        .accessibilitySortPriority(1)
    }

    private var bottomBar: some View {
        VStack(spacing: 14) {
            HStack(spacing: 7) {
                ForEach(pages, id: \.self) { dot in
                    Circle()
                        .fill(dot == page ? AtlasTheme.sepia : AtlasTheme.ruleSoft)
                        .frame(width: 6, height: 6)
                }
            }
            .accessibilityHidden(true)
            primaryControl
        }
        .padding(.horizontal, 22)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(AtlasTheme.paper)
        .overlay(alignment: .top) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
    }

    @ViewBuilder
    private var primaryControl: some View {
        switch page {
        case .welcome:
            AccessPrimaryButton(title: "BEGIN", subtitle: nil, isBusy: false, isEnabled: true, identifier: "onboarding.begin", action: advance)
        case .weekly, .witness, .acts:
            AccessPrimaryButton(title: "CONTINUE", subtitle: nil, isBusy: false, isEnabled: true, identifier: "onboarding.continue", action: advance)
        case .reminder:
            Button(action: advance) {
                Text("NOT NOW")
                    .font(AtlasType.technical(11, weight: .bold)).tracking(1.2)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("onboarding.reminder.notNow")
        case .works:
            AccessPrimaryButton(
                title: mode == .firstRun ? "MEET THIS WEEK’S SPECIES" : "BACK TO THE INDEX",
                subtitle: mode == .firstRun ? weeklyName.map { "The \($0.lowercased())" } : nil,
                isBusy: false,
                isEnabled: true,
                identifier: "onboarding.finish"
            ) {
                finish(skipped: false)
            }
        }
    }

    // MARK: - Flow

    private func advance() {
        guard let index = pages.firstIndex(of: page), index + 1 < pages.count else {
            finish(skipped: false)
            return
        }
        let next = pages[index + 1]
        if reduceMotion {
            page = next
        } else {
            withAnimation(.easeInOut(duration: 0.35)) { page = next }
        }
    }

    private func choose(_ preset: (label: String, hour: Int, minute: Int)) {
        // Intent only: no notification API is touched here (D-008, D-026).
        reminders.setPreferredTime(hour: preset.hour, minute: preset.minute)
        reminderChoice = preset.label.lowercased()
        advance()
    }

    private func finish(skipped: Bool) {
        switch mode {
        case .review:
            dismiss()
        case .firstRun:
            onFinish(Outcome(pagesSeen: furthestIndex + 1, skipped: skipped, reminder: reminderChoice))
        }
    }

    private static func timeLabel(hour: Int, minute: Int) -> String {
        let date = Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? .now
        return date.formatted(date: .omitted, time: .shortened)
    }
}
