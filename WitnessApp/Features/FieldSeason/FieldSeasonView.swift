import CoreTransferable
import SwiftUI
import WitnessCore

/// The keepsake album, rendered only when the user actually exports it.
struct FieldAlbumExport: Transferable {
    let edition: FieldSeasonEdition

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .pdf) { export in
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("Witness-Field-Season-One.pdf")
            try await MainActor.run {
                try FieldAlbumComposer.render(edition: export.edition, to: url)
            }
            return SentTransferredFile(url)
        }
    }
}

/// The owned Field Season edition: chapter list and reading/listening
/// entry. Reached only from entitled states, and still fails closed —
/// without access it shows a quiet notice, never premium content.
struct FieldSeasonView: View {
    @ObservedObject var commerce: CommerceModel
    private let edition = FieldSeasonLoader.loadBundledEdition()

    private var isEntitled: Bool {
        commerce.ownsFieldSeason || commerce.atlasIsActive
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                if !isEntitled {
                    AccessStateNotice(
                        text: "Field Season requires permanent ownership or an active Atlas membership.",
                        identifier: "fieldseason.locked"
                    )
                } else if let edition {
                    Text(edition.title.uppercased())
                        .font(AtlasType.display(30, weight: .semibold))
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityIdentifier("fieldseason.title")

                    Text("A finite, authored edition — complete at twelve pieces. Every piece shipped only after sources, rights, and review were finished.")
                        .font(.footnote)
                        .foregroundStyle(AtlasTheme.inkMuted)
                        .lineSpacing(3)

                    AccessSectionHeading(text: "THE EDITION")
                    ForEach(edition.chapters) { chapter in
                        NavigationLink {
                            ChapterReaderView(chapter: chapter)
                        } label: {
                            chapterRow(chapter)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier(
                            chapter.resolvedKind == .chapter
                                ? "fieldseason.chapter.\(chapter.number)"
                                : "fieldseason.piece.\(chapter.id)"
                        )
                    }

                    albumExport(edition)

                    let shippedChapters = edition.chapters.filter { $0.resolvedKind == .chapter }.count
                    if shippedChapters < edition.plannedChapterCount {
                        ForEach(shippedChapters + 1 ... edition.plannedChapterCount, id: \.self) { number in
                            plannedRow(number)
                        }
                        Text("Purchasing before completion means the finished chapters arrive as free updates to this same edition.")
                            .font(.footnote)
                            .foregroundStyle(AtlasTheme.inkMuted)
                            .lineSpacing(3)
                    }
                } else {
                    AccessStateNotice(
                        text: "The edition could not be loaded in this build.",
                        identifier: "fieldseason.missing"
                    )
                }
            }
            .padding(22)
            .foregroundStyle(AtlasTheme.ink)
        }
        .background(AtlasPaper().ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chapterRow(_ chapter: FieldSeasonChapter) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(rowMark(chapter))
                .font(AtlasType.display(22, weight: .medium))
                .foregroundStyle(AtlasTheme.sepia)
                .frame(minWidth: 30, alignment: .leading)
            VStack(alignment: .leading, spacing: 3) {
                Text(chapter.title)
                    .font(AtlasType.display(18, weight: .medium))
                    .multilineTextAlignment(.leading)
                Text(rowSubtitle(chapter))
                    .font(AtlasType.technical(10, weight: .medium))
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AtlasTheme.inkMuted)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1)
        }
    }

    /// One tap renders the season into a keepsake PDF and hands it to the
    /// share sheet — the plate as cover, every piece, every door as a link.
    private func albumExport(_ edition: FieldSeasonEdition) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            AccessSectionHeading(text: "THE FIELD ALBUM")
            ShareLink(
                item: FieldAlbumExport(edition: edition),
                preview: SharePreview("Witness — \(edition.title)", image: Image("season-plate-01"))
            ) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Image(systemName: "square.and.arrow.down.on.square")
                        .font(.title3)
                        .foregroundStyle(AtlasTheme.sepia)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Export the season as a field album")
                            .font(AtlasType.display(16, weight: .medium))
                        Text("A keepsake PDF — the plate as cover, every piece, every door. Yours to keep and pass on.")
                            .font(.footnote)
                            .foregroundStyle(AtlasTheme.inkMuted)
                            .lineSpacing(3)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AtlasTheme.paperFresh, in: RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(AtlasTheme.sepia.opacity(0.35), lineWidth: 1)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("fieldseason.album.export")
        }
        .padding(.top, 8)
    }

    /// Chapters keep their number; the letter, interludes, and synthesis
    /// carry a mark instead, so the shelf reads like a bound edition.
    private func rowMark(_ chapter: FieldSeasonChapter) -> String {
        switch chapter.resolvedKind {
        case .chapter: String(format: "%02d", chapter.number)
        case .letter: "✦"
        case .interlude: "·"
        case .synthesis: "✦"
        }
    }

    private func rowSubtitle(_ chapter: FieldSeasonChapter) -> String {
        let kindPart: String? = switch chapter.resolvedKind {
        case .chapter: nil
        case .letter: "OPENING FIELD LETTER"
        case .interlude: "INTERLUDE"
        case .synthesis: "CLOSING SYNTHESIS"
        }
        let readPart = if let audio = chapter.audio {
            "READ · LISTEN \(ChapterAudioPlayer.timestamp(audio.durationSeconds))"
        } else {
            "READ"
        }
        if let kindPart {
            return "\(kindPart) · \(readPart)"
        }
        return readPart
    }

    private func plannedRow(_ number: Int) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(String(format: "%02d", number))
                .font(AtlasType.display(22, weight: .medium))
                .foregroundStyle(AtlasTheme.inkMuted.opacity(0.5))
            Text("IN PRODUCTION")
                .font(AtlasType.technical(11, weight: .medium))
                .foregroundStyle(AtlasTheme.inkMuted)
            Spacer()
        }
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Chapter \(number): in production")
    }
}
