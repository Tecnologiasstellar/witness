import SwiftUI
import WitnessCore

/// Preview and purchase surface for the first Field Season edition —
/// presented like the cover of a bound book: the season plate, the real
/// contents, and the opening letter's narration to taste before buying.
/// Permanent one-edition ownership; included while Atlas is active.
struct FieldSeasonPreviewView: View {
    @ObservedObject var commerce: CommerceModel
    @StateObject private var samplePlayer = ChapterAudioPlayer()

    private let edition = FieldSeasonLoader.loadBundledEdition()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("FIELD SEASON")
                    .font(AtlasType.display(30, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)

                seasonPlate

                Text("A finite, authored edition about one ecological edge: its species, pressures, uncertainties, and possible forms of attention. Purchasing keeps this edition permanently — it is not a subscription.")
                    .font(.callout)
                    .lineSpacing(4)

                if let edition {
                    statRow(edition)
                    sampleRow(edition)
                    contents(edition)
                }

                AccessStateNotice(
                    text: "This edition is complete: twelve pieces, every one shipped only after sources, rights, and review were finished. Corrections and accessibility updates arrive free.",
                    identifier: "access.fieldseason.production.notice"
                )

                AccessSectionHeading(text: "WHAT PERMANENT MEANS")
                Text("The purchased edition, its corrections, and its accessibility updates remain yours through your Apple account, restorable on this and future devices. It does not include future seasons, the Atlas library, or any claim of a conservation outcome. While an Atlas membership is active, this season is already included.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)

                purchaseArea

                PurchasePhaseNotice(purchasePhase: commerce.purchasePhase, restorePhase: commerce.restorePhase)

                AccessQuietRow(title: "RESTORE PURCHASES", identifier: "access.fieldseason.restore") {
                    Task { await commerce.restore() }
                }

                Text("Your Witness remains free. The complete public record, sources, action, count, and your private reflections never require a purchase.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)
            }
            .padding(22)
            .foregroundStyle(AtlasTheme.ink)
        }
        .background(AtlasPaper().ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { await commerce.startIfNeeded() }
        .onDisappear {
            commerce.clearTransientPhases()
            samplePlayer.stop()
        }
    }

    // MARK: - Cover

    @ViewBuilder
    private var seasonPlate: some View {
        if UIImage(named: "season-plate-01") != nil {
            VStack(alignment: .leading, spacing: 8) {
                Image("season-plate-01")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                Text("THE COUNTED FEW · SEASON PLATE")
                    .font(AtlasType.technical(9, weight: .medium))
                    .tracking(1.1)
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("The season plate, titled The Counted Few: the eight species of the edition drawn together")
        }
    }

    private func statRow(_ edition: FieldSeasonEdition) -> some View {
        let chapterCount = edition.chapters.filter { $0.resolvedKind == .chapter }.count
        let narratedMinutes = Int((edition.chapters.compactMap { $0.audio?.durationSeconds }.reduce(0, +) / 60).rounded())
        return HStack(spacing: 10) {
            statTile(value: "\(edition.chapters.count)", label: "PIECES")
            statTile(value: "\(chapterCount)", label: "SPECIES")
            statTile(value: "\(narratedMinutes) MIN", label: "NARRATED")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(edition.chapters.count) pieces, \(chapterCount) species, \(narratedMinutes) minutes narrated")
    }

    private func statTile(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(AtlasType.technical(9, weight: .bold))
                .tracking(1.1)
                .foregroundStyle(AtlasTheme.sepia)
            Text(value)
                .font(AtlasType.display(20, weight: .semibold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AtlasTheme.paperFresh)
        .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
    }

    // MARK: - Taste

    /// The opening letter's full narration, playable before any purchase —
    /// the edition's honest sample.
    @ViewBuilder
    private func sampleRow(_ edition: FieldSeasonEdition) -> some View {
        if let letter = edition.chapters.first(where: { $0.resolvedKind == .letter }), let audio = letter.audio {
            Button {
                samplePlayer.load(audio)
                samplePlayer.toggle()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: samplePlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundStyle(AtlasTheme.sepia)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("HEAR THE OPENING")
                            .font(AtlasType.technical(10, weight: .bold))
                            .tracking(1.1)
                            .foregroundStyle(AtlasTheme.sepia)
                        Text("“\(letter.title)” · \(ChapterAudioPlayer.timestamp(audio.durationSeconds))")
                            .font(AtlasType.display(15, weight: .medium))
                            .foregroundStyle(AtlasTheme.ink)
                    }
                    Spacer()
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AtlasTheme.paperFresh)
                .overlay(Rectangle().stroke(AtlasTheme.sepia.opacity(0.35), lineWidth: 1))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("access.fieldseason.sample")
            .accessibilityLabel(samplePlayer.isPlaying ? "Pause the opening letter narration" : "Play the opening letter narration, \(letter.title)")
        }
    }

    // MARK: - Contents

    private func contents(_ edition: FieldSeasonEdition) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            AccessSectionHeading(text: "THE EDITION CONTAINS")
                .padding(.bottom, 4)
            ForEach(edition.chapters) { piece in
                contentsRow(piece)
            }
        }
    }

    private func contentsRow(_ piece: FieldSeasonChapter) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(rowMark(piece))
                .font(AtlasType.display(18, weight: .medium))
                .foregroundStyle(AtlasTheme.sepia)
                .frame(minWidth: 26, alignment: .leading)
            VStack(alignment: .leading, spacing: 2) {
                Text(piece.title)
                    .font(AtlasType.display(16, weight: .medium))
                    .multilineTextAlignment(.leading)
                Text(rowSubtitle(piece))
                    .font(AtlasType.technical(9, weight: .medium))
                    .tracking(0.8)
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            Spacer()
            if piece.resolvedKind == .chapter,
               let assetID = piece.heroAssetID, UIImage(named: assetID) != nil {
                Image(assetID)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipped()
                    .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 9)
        .overlay(alignment: .bottom) {
            Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private func rowMark(_ piece: FieldSeasonChapter) -> String {
        switch piece.resolvedKind {
        case .chapter: String(format: "%02d", piece.number)
        case .letter: "✦"
        case .interlude: "·"
        case .synthesis: "✦"
        }
    }

    private func rowSubtitle(_ piece: FieldSeasonChapter) -> String {
        switch piece.resolvedKind {
        case .chapter: "CHAPTER · FREE RECORD + PREMIUM DOSSIER"
        case .letter: "OPENING FIELD LETTER"
        case .interlude: "INTERLUDE"
        case .synthesis: "CLOSING SYNTHESIS + SEASON PLATE"
        }
    }

    // MARK: - Purchase

    @ViewBuilder
    private var purchaseArea: some View {
        if commerce.ownsFieldSeason {
            AccessStateNotice(
                text: "Field Season is yours permanently.",
                identifier: "access.fieldseason.owned"
            )
            openEditionLink
        } else if commerce.atlasIsActive {
            AccessStateNotice(
                text: "Included with your active Atlas membership. If Atlas ever lapses, the season remains readable only with a separate permanent purchase.",
                identifier: "access.fieldseason.included"
            )
            openEditionLink
        } else {
            switch commerce.productsState {
            case .loading:
                HStack(spacing: 10) {
                    ProgressView()
                    Text("Checking the store…")
                        .font(AtlasType.technical(11, weight: .medium))
                        .foregroundStyle(AtlasTheme.inkMuted)
                }
                .frame(minHeight: 52)
                .accessibilityIdentifier("access.fieldseason.loading")
            case .unavailable(let message):
                AccessStateNotice(text: message, identifier: "access.fieldseason.unavailable")
                AccessQuietRow(title: "TRY AGAIN", identifier: "access.fieldseason.retry") {
                    Task { await commerce.refresh() }
                }
            case .ready:
                if let product = commerce.fieldSeasonProduct {
                    AccessPrimaryButton(
                        title: "KEEP FIELD SEASON PERMANENTLY",
                        subtitle: "\(product.localizedPrice) · one-time purchase",
                        isBusy: commerce.purchasePhase == .purchasing(productID: product.id),
                        isEnabled: true,
                        identifier: "access.fieldseason.purchase"
                    ) {
                        Task { await commerce.purchase(productID: product.id) }
                    }
                } else {
                    AccessStateNotice(
                        text: "Field Season is not available in this build.",
                        identifier: "access.fieldseason.missing"
                    )
                }
            }
        }
    }

    private var openEditionLink: some View {
        NavigationLink {
            FieldSeasonView(commerce: commerce)
        } label: {
            HStack {
                Text("OPEN THE EDITION")
                    .font(AtlasType.technical(12, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right").font(.caption)
            }
            .foregroundStyle(AtlasTheme.sepia)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("access.fieldseason.open")
    }
}
