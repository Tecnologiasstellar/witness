import SwiftUI
import WitnessCore

/// Reading and listening surface for one Field Season chapter. Renders the
/// reviewed section data in the Atlas plate language; the narration bar
/// appears only when the audio file actually ships in this build.
struct ChapterReaderView: View {
    let chapter: FieldSeasonChapter
    @StateObject private var audio = ChapterAudioPlayer()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                header
                if let chapterAudio = chapter.audio {
                    audioBar(chapterAudio)
                }
                ForEach(chapter.sections) { section in
                    sectionView(section)
                }
            }
            .padding(22)
            .foregroundStyle(AtlasTheme.ink)
        }
        .background(AtlasPaper().ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let chapterAudio = chapter.audio {
                audio.load(chapterAudio)
            }
        }
        .onDisappear { audio.stop() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CHAPTER \(String(format: "%02d", chapter.number))")
                .font(AtlasType.technical(11, weight: .medium))
                .foregroundStyle(AtlasTheme.sepia)
            Text(chapter.title)
                .font(AtlasType.display(30, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
                .accessibilityIdentifier("fieldseason.reader.title")
            if let heroAssetID = chapter.heroAssetID, UIImage(named: heroAssetID) != nil {
                Image(heroAssetID)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(AtlasTheme.ruleSoft, lineWidth: 1)
                    )
                    .accessibilityHidden(true)
            }
        }
    }

    private func audioBar(_ chapterAudio: FieldSeasonAudio) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if audio.isAvailable {
                HStack(spacing: 14) {
                    Button {
                        audio.toggle()
                    } label: {
                        Image(systemName: audio.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(AtlasTheme.sepia)
                    }
                    .accessibilityLabel(audio.isPlaying ? "Pause narration" : "Play narration")
                    .accessibilityIdentifier("fieldseason.audio.toggle")

                    VStack(alignment: .leading, spacing: 5) {
                        Slider(
                            value: Binding(
                                get: {
                                    audio.duration > 0 ? audio.currentTime / audio.duration : 0
                                },
                                set: { audio.seek(to: $0) }
                            )
                        )
                        .tint(AtlasTheme.sepia)
                        .accessibilityLabel("Narration position")
                        HStack {
                            Text(ChapterAudioPlayer.timestamp(audio.currentTime))
                            Spacer()
                            Text(ChapterAudioPlayer.timestamp(audio.duration))
                        }
                        .font(AtlasType.technical(10, weight: .medium))
                        .foregroundStyle(AtlasTheme.inkMuted)
                    }
                }
            } else {
                Text("Narration is not included in this build.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
            }
            Text(chapterAudio.voiceDisclosure)
                .font(AtlasType.technical(10, weight: .medium))
                .foregroundStyle(AtlasTheme.inkMuted)
                .accessibilityIdentifier("fieldseason.audio.disclosure")
        }
        .padding(14)
        .background(AtlasTheme.paperFresh, in: RoundedRectangle(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(AtlasTheme.ruleSoft, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func sectionView(_ section: FieldSeasonSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if section.style != .prompt {
                AccessSectionHeading(text: section.heading)
            }
            switch section.style {
            case .prose:
                ForEach(section.entries) { entry in
                    Text(entry.text)
                        .font(.callout)
                        .lineSpacing(5)
                }
            case .numbered:
                ForEach(Array(section.entries.enumerated()), id: \.element.id) { index, entry in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("\(index + 1)")
                            .font(AtlasType.display(20, weight: .medium))
                            .foregroundStyle(AtlasTheme.sepia)
                        VStack(alignment: .leading, spacing: 3) {
                            if let lead = entry.lead {
                                Text(lead).font(.callout.weight(.semibold))
                            }
                            Text(entry.text).font(.callout).lineSpacing(4)
                        }
                    }
                }
            case .timeline:
                ForEach(section.entries) { entry in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text(entry.lead ?? "")
                            .font(AtlasType.technical(12, weight: .semibold))
                            .foregroundStyle(AtlasTheme.sepia)
                            .frame(width: 64, alignment: .leading)
                        Text(entry.text).font(.footnote).lineSpacing(4)
                    }
                    .padding(.vertical, 2)
                }
            case .knownUnknown:
                ForEach(section.entries) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text((entry.lead ?? "").uppercased())
                            .font(AtlasType.technical(10, weight: .semibold))
                            .foregroundStyle(AtlasTheme.sepia)
                        Text(entry.text).font(.footnote).lineSpacing(4)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AtlasTheme.paperFresh, in: RoundedRectangle(cornerRadius: 6))
                }
            case .prompt:
                promptView(section)
            case .sources:
                ForEach(section.entries) { entry in
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        if let lead = entry.lead {
                            Text(lead)
                                .font(AtlasType.technical(10, weight: .semibold))
                                .foregroundStyle(AtlasTheme.sepia)
                        }
                        Text(entry.text)
                            .font(.caption)
                            .foregroundStyle(AtlasTheme.inkMuted)
                            .lineSpacing(3)
                    }
                }
            }
        }
    }

    /// The reflective prompt sits apart, set like an inscription.
    private func promptView(_ section: FieldSeasonSection) -> some View {
        VStack(spacing: 14) {
            Rectangle().fill(AtlasTheme.sepia).frame(width: 56, height: 1)
            ForEach(section.entries) { entry in
                Text(entry.text)
                    .font(AtlasType.display(19, weight: .regular, italic: true))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            Rectangle().fill(AtlasTheme.sepia).frame(width: 56, height: 1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
