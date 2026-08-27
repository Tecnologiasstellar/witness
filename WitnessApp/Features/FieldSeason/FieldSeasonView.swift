import SwiftUI
import WitnessCore

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

                    Text("A finite, authored edition. Chapters appear here as each one finishes sources, rights, and review.")
                        .font(.footnote)
                        .foregroundStyle(AtlasTheme.inkMuted)
                        .lineSpacing(3)

                    AccessSectionHeading(text: "CHAPTERS")
                    ForEach(edition.chapters) { chapter in
                        NavigationLink {
                            ChapterReaderView(chapter: chapter)
                        } label: {
                            chapterRow(chapter)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("fieldseason.chapter.\(chapter.number)")
                    }

                    if edition.chapters.count < edition.plannedChapterCount {
                        ForEach(edition.chapters.count + 1 ... edition.plannedChapterCount, id: \.self) { number in
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
            Text(String(format: "%02d", chapter.number))
                .font(AtlasType.display(22, weight: .medium))
                .foregroundStyle(AtlasTheme.sepia)
            VStack(alignment: .leading, spacing: 3) {
                Text(chapter.title)
                    .font(AtlasType.display(18, weight: .medium))
                    .multilineTextAlignment(.leading)
                if let audio = chapter.audio {
                    Text("READ · LISTEN \(ChapterAudioPlayer.timestamp(audio.durationSeconds))")
                        .font(AtlasType.technical(10, weight: .medium))
                        .foregroundStyle(AtlasTheme.inkMuted)
                } else {
                    Text("READ")
                        .font(AtlasType.technical(10, weight: .medium))
                        .foregroundStyle(AtlasTheme.inkMuted)
                }
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
