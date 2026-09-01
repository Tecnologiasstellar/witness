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
        .toolbar {
            if let shareText = chapter.shareText, !shareText.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: shareText) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(AtlasTheme.sepia)
                    }
                    .accessibilityLabel("Share this piece")
                    .accessibilityIdentifier("fieldseason.reader.share")
                }
            }
        }
        .task {
            if let chapterAudio = chapter.audio {
                audio.load(chapterAudio)
            }
        }
        .onDisappear { audio.stop() }
    }

    private var kindLabel: String {
        switch chapter.resolvedKind {
        case .chapter: "CHAPTER \(String(format: "%02d", chapter.number))"
        case .letter: "OPENING FIELD LETTER"
        case .interlude: "INTERLUDE"
        case .synthesis: "CLOSING SYNTHESIS"
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(kindLabel)
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
            case .action:
                // The hand-off happens in the story's own voice — a serif
                // aside, then one unmistakable door. The first organization
                // gets the letterpress treatment; the rest stay quiet cards.
                VStack(spacing: 14) {
                    Rectangle().fill(AtlasTheme.sepia).frame(width: 56, height: 1)
                    Text("The story is told. What remains is a door — real people already doing this work, and a way to stand with them.")
                        .font(AtlasType.display(18, weight: .regular, italic: true))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    Rectangle().fill(AtlasTheme.sepia).frame(width: 56, height: 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                ForEach(Array(section.entries.enumerated()), id: \.element.id) { index, entry in
                    if index == 0 {
                        primaryActionDoor(entry)
                    } else {
                        actionDoor(entry)
                    }
                }
                Text("These organizations are independent of Witness. Links open in your browser; any support goes directly to them.")
                    .font(AtlasType.technical(10, weight: .medium))
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)
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

    /// The chapter's first door, set like a letterpress plate — the one
    /// action a moved reader should not be able to miss.
    @ViewBuilder
    private func primaryActionDoor(_ entry: FieldSeasonEntry) -> some View {
        if let urlString = entry.url, let url = URL(string: urlString) {
            Link(destination: url) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 10) {
                        Text("OPEN THE DOOR · \((entry.lead ?? "").uppercased())")
                            .font(AtlasType.technical(11, weight: .bold)).tracking(1.2)
                            .lineLimit(1).minimumScaleFactor(0.65)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption.weight(.bold))
                    }
                    Text(entry.text)
                        .font(AtlasType.display(15, weight: .regular, italic: true))
                        .opacity(0.9)
                        .lineSpacing(3)
                        .multilineTextAlignment(.leading)
                }
                .foregroundStyle(AtlasTheme.paper)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AtlasTheme.ink)
                .overlay(
                    Rectangle()
                        .strokeBorder(AtlasTheme.paper.opacity(0.35), lineWidth: 1)
                        .padding(3)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(AtlasPressStyle())
            .accessibilityLabel("Open the door at \(entry.lead ?? "the organization"): \(entry.text). Opens in browser.")
            .accessibilityIdentifier("fieldseason.reader.primaryDoor")
        }
    }

    /// One door to a real organization: name, what support does, and the
    /// verified link. The loader has already refused any entry without one.
    @ViewBuilder
    private func actionDoor(_ entry: FieldSeasonEntry) -> some View {
        if let urlString = entry.url, let url = URL(string: urlString) {
            Link(destination: url) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.lead ?? "")
                            .font(.callout.weight(.semibold))
                        Text(entry.text)
                            .font(.footnote)
                            .foregroundStyle(AtlasTheme.inkMuted)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AtlasTheme.sepia)
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
            .accessibilityLabel("\(entry.lead ?? "Organization"): \(entry.text). Opens in browser.")
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
