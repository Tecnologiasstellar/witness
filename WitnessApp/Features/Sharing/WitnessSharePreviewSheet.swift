import CoreTransferable
import SwiftUI
import UniformTypeIdentifiers
import WitnessCore

struct WitnessSharePreviewSheet: View {
    let species: SpeciesRecord
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var renderedImage: UIImage?
    @State private var renderedPNG: Data?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    WitnessShareCard(species: species)
                        .frame(width: 320, height: 400)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Share card for \(species.commonName). \(species.hook)")

                    Text("Sharing expresses attention, not a conservation outcome. Your private reflection is never included.")
                        .font(.footnote)
                        .foregroundStyle(AtlasTheme.inkMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    if let renderedImage, let data = renderedPNG {
                        ShareLink(
                            item: ShareCardArtifact(pngData: data),
                            subject: Text("Witnessed: \(species.commonName)"),
                            message: Text(WitnessShareCopy.make(for: species)),
                            preview: SharePreview(
                                "Witnessed: \(species.commonName)",
                                image: Image(uiImage: renderedImage)
                            )
                        ) {
                            Label("Share this card", systemImage: "square.and.arrow.up")
                                .font(AtlasType.technical(11, weight: .bold))
                                .tracking(1.1)
                                .foregroundStyle(AtlasTheme.paper)
                                .frame(maxWidth: .infinity, minHeight: 54)
                                .background(AtlasTheme.ink)
                        }
                        .padding(.horizontal, 24)
                        .accessibilityIdentifier("share.exportButton")
                    } else {
                        ProgressView("Preparing your card…")
                            .frame(minHeight: 54)
                    }
                }
                .padding(.vertical, 24)
            }
            .background(AtlasPaper())
            .navigationTitle("SHARE PLATE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .task { await renderShareCard() }
    }

    @MainActor
    private func renderShareCard() async {
        let card = WitnessShareCard(species: species)
            .frame(width: 360, height: 450)
        let renderer = ImageRenderer(content: card)
        renderer.scale = 3
        guard let image = renderer.uiImage else { return }
        // Encode once, off the main thread; body used to re-encode on every pass.
        let data = await Task.detached(priority: .userInitiated, operation: { image.pngData() }).value
        renderedImage = image
        renderedPNG = data
    }
}

private struct WitnessShareCard: View {
    let species: SpeciesRecord

    var body: some View {
        ZStack {
            AtlasPaper()
            PlateFrame()
            VStack(spacing: 10) {
                Text("WITNESSED")
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.5)
                    .foregroundStyle(AtlasTheme.sepia)
                SpecimenPlate(species: species, showsLeaderLabels: false).frame(height: 168)
                Text(species.commonName.uppercased())
                    .font(AtlasType.display(30, weight: .semibold)).multilineTextAlignment(.center)
                Text(species.scientificName)
                    .font(AtlasType.display(14, italic: true)).foregroundStyle(AtlasTheme.inkMuted)
                // Share cards never carry a count claim: an exported image
                // goes stale the moment it leaves the device.
                AtlasTally(count: nil, lastVerified: species.editorial.lastFactChecked)
                Spacer(minLength: 0)
                HStack {
                    AtlasIconView(icon: .fieldMark, size: 14)
                    Text("WITNESS")
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                    Spacer()
                    Text("NO CONSERVATION CLAIM")
                        .font(AtlasType.technical(7.5, weight: .semibold)).tracking(0.7)
                }
                .foregroundStyle(AtlasTheme.sepia)
            }
            .padding(24).foregroundStyle(AtlasTheme.ink)
        }
    }
}

private struct ShareCardArtifact: Transferable {
    let pngData: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { artifact in
            artifact.pngData
        }
    }
}
