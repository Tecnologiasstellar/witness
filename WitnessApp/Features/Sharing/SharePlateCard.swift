import SwiftUI
import UIKit
import WitnessCore

/// The social share artifact: an Instagram-native 4:5 plate rendered from the
/// species' real artwork and identity. Per the trust policy it carries no
/// count, no reflection, and no outcome claim — only the animal, its status,
/// its hook, and the Witness mark.
struct SharePlateView: View {
    let species: SpeciesRecord

    // Fixed design-space size; rendered at 2x → 1080×1350.
    static let size = CGSize(width: 540, height: 675)

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let hero = species.gallery?.first, let image = UIImage(named: hero) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Self.size.width, height: Self.size.height)
                    .clipped()
            } else {
                AtlasTheme.paper
                SpecimenPlate(species: species, showsLeaderLabels: false)
                    .padding(40)
            }

            LinearGradient(
                colors: [AtlasTheme.heroScrim.opacity(0.96), AtlasTheme.heroScrim.opacity(0.6), .clear],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 330)
            .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 10) {
                Text(species.conservationStatus.displayName.uppercased())
                    .font(.system(size: 13, weight: .bold)).tracking(2.0)
                    .padding(.horizontal, 14).padding(.vertical, 7)
                    .overlay(Capsule().stroke(AtlasTheme.heroInk.opacity(0.6), lineWidth: 1))
                Text(species.commonName.uppercased())
                    .font(.system(size: 46, weight: .semibold, design: .serif))
                    .minimumScaleFactor(0.6).lineLimit(2)
                Text(species.scientificName)
                    .font(.system(size: 19, design: .serif).italic())
                Rectangle().fill(AtlasTheme.heroInk.opacity(0.45)).frame(width: 52, height: 1.5)
                    .padding(.vertical, 4)
                Text(species.hook)
                    .font(.system(size: 21, design: .serif).italic())
                    .lineSpacing(4)
                    .padding(.trailing, 30)
                HStack(spacing: 9) {
                    AtlasIconView(icon: .fieldMark, size: 15, color: AtlasTheme.heroInk)
                    Text("WITNESS")
                        .font(.system(size: 13, weight: .bold)).tracking(2.6)
                    Text("· ONE SPECIES A DAY")
                        .font(.system(size: 11, weight: .medium)).tracking(1.8)
                        .opacity(0.75)
                }
                .padding(.top, 14)
            }
            .foregroundStyle(AtlasTheme.heroInk)
            .padding(28)
        }
        .frame(width: Self.size.width, height: Self.size.height)
        .background(AtlasTheme.paper)
        .environment(\.colorScheme, .light)
    }
}

/// Transferable PNG for the system share sheet (Instagram, WhatsApp, Messages…).
struct SharePlate: Transferable {
    let pngData: Data
    let commonName: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { plate in plate.pngData }
    }

    @MainActor
    static func render(for species: SpeciesRecord) -> SharePlate? {
        let renderer = ImageRenderer(content: SharePlateView(species: species))
        renderer.scale = 2
        renderer.proposedSize = ProposedViewSize(SharePlateView.size)
        guard let image = renderer.uiImage, let data = image.pngData() else { return nil }
        return SharePlate(pngData: data, commonName: species.commonName)
    }
}

/// The ceremonial share affordance, used at the witness climax and in the
/// Cabinet. Renders lazily and hands the plate to the system share sheet.
struct SharePlateButton: View {
    let species: SpeciesRecord
    var prominent = false
    @State private var plate: SharePlate?

    var body: some View {
        Group {
            if let plate {
                ShareLink(
                    item: plate,
                    message: Text("I witnessed the \(species.commonName) today. One species a day, on Witness."),
                    preview: SharePreview(
                        "\(species.commonName) — Witness",
                        image: Image(uiImage: UIImage(data: plate.pngData) ?? UIImage())
                    )
                ) {
                    label
                }
                .simultaneousGesture(TapGesture().onEnded {
                    let name = species.id
                    Task.detached { await WitnessSync.shared.logEvent("share_created", metadata: ["species": name]) }
                })
            } else {
                label.opacity(0.4)
            }
        }
        .task { plate = SharePlate.render(for: species) }
        .accessibilityIdentifier("share.plateButton")
    }

    private var label: some View {
        HStack(spacing: 10) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 15, weight: .semibold))
            Text("SHARE THIS PLATE")
                .font(AtlasType.technical(11, weight: .bold)).tracking(1.3)
            Spacer()
            Text("INSTAGRAM · WHATSAPP · ANYWHERE")
                .font(AtlasType.technical(8, weight: .medium)).tracking(0.9)
                .foregroundStyle(prominent ? AtlasTheme.paper.opacity(0.7) : AtlasTheme.inkMuted)
                .lineLimit(1).minimumScaleFactor(0.7)
        }
        .foregroundStyle(prominent ? AtlasTheme.paper : AtlasTheme.sepia)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 52)
        .background(prominent ? AtlasTheme.sepia : .clear)
        .overlay(Rectangle().stroke(prominent ? AtlasTheme.sepia : AtlasTheme.ruleSoft, lineWidth: 1))
    }
}
