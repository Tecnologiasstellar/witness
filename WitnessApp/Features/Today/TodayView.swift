import SwiftUI
import WitnessCore

struct TodayView: View {
    @ObservedObject var model: AppModel
    let onOpenIndex: () -> Void
    let onOpenReflection: () -> Void
    let onWitnessed: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var showsSpecimen = false
    @State private var showsSharePreview = false

    var body: some View {
        Group {
            if let species = model.species {
                if dynamicTypeSize.isAccessibilitySize {
                    ScrollView { plate(for: species).frame(minHeight: 720) }
                        .scrollIndicators(.hidden)
                } else {
                    plate(for: species)
                }
            } else {
                loadFailure
            }
        }
        .background(AtlasTheme.paper.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showsSpecimen) {
            if let species = model.species { SpecimenDetailView(species: species) }
        }
        .sheet(isPresented: $showsSharePreview) {
            if let species = model.species { WitnessSharePreviewSheet(species: species) }
        }
    }

    private func plate(for species: SpeciesRecord) -> some View {
        GeometryReader { proxy in
            ZStack {
                PlateFrame()
                VStack(spacing: 0) {
                    header
                    statusLine(species).padding(.top, 10)
                    Button { showsSpecimen = true } label: {
                        SpecimenPlate(species: species, showsLeaderLabels: true)
                            .frame(height: min(202, max(156, proxy.size.height * 0.275)))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("today.specimenButton")
                    .accessibilityHint("Opens the specimen figures for range, prey and cause")
                    .contextMenu { Button("Preview share plate") { showsSharePreview = true } }

                    AtlasScaleRule().padding(.horizontal, 28)
                    specimenName(species)
                    AtlasTally(lastVerified: species.editorial.lastFactChecked).padding(.top, 10)
                    Spacer(minLength: 8)
                    witnessControl
                }
                .padding(.horizontal, 22)
                .padding(.top, 8)
                .padding(.bottom, 14)
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack {
            Button(action: onOpenIndex) {
                AtlasIconView(icon: .contents, size: 18).frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Contents index")
            .accessibilityIdentifier("today.contents")
            Spacer()
            Text(dateStamp)
                .font(AtlasType.technical(10, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(AtlasTheme.sepia)
            Spacer()
            Button(action: onOpenReflection) {
                AtlasIconView(icon: .nib, size: 18).frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Add a private note")
            .accessibilityIdentifier("today.privateNote")
        }
    }

    private func statusLine(_ species: SpeciesRecord) -> some View {
        Text("STATUS · \(species.conservationStatus.displayName.uppercased())")
            .font(AtlasType.technical(10, weight: .semibold))
            .tracking(1.25)
            .foregroundStyle(AtlasTheme.sepia)
            .accessibilityLabel("Conservation status: \(species.conservationStatus.displayName)")
    }

    private func specimenName(_ species: SpeciesRecord) -> some View {
        VStack(spacing: 4) {
            Text(species.commonName.uppercased())
                .font(dynamicTypeSize.isAccessibilitySize ? .title2.weight(.semibold) : AtlasType.display(33, weight: .semibold))
                .tracking(dynamicTypeSize.isAccessibilitySize ? 0 : AtlasType.tracking(0.06, at: 33, dynamicTypeSize: dynamicTypeSize))
                .minimumScaleFactor(0.78)
                .lineLimit(1)
            Text(species.scientificName)
                .font(AtlasType.display(15, weight: .regular).italic())
                .foregroundStyle(AtlasTheme.inkMuted)
        }
        .foregroundStyle(AtlasTheme.ink)
        .multilineTextAlignment(.center)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(species.commonName), \(species.scientificName)")
    }

    private var witnessControl: some View {
        VStack(spacing: 7) {
            Button {
                Task {
                    await model.witness()
                    if model.isWitnessed { onWitnessed() }
                }
            } label: {
                HStack(spacing: 10) {
                    AtlasIconView(icon: .fieldMark, size: 17)
                    Text(model.isSaving ? "RECORDING" : (model.isWitnessed ? "WITNESSED" : "WITNESS"))
                        .font(AtlasType.technical(12, weight: .bold))
                        .tracking(1.45)
                }
                .foregroundStyle(model.isWitnessed ? AtlasTheme.accentSage : AtlasTheme.paper)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(model.isWitnessed ? AtlasTheme.accentSage.opacity(0.13) : AtlasTheme.ink)
                .overlay(Rectangle().stroke(AtlasTheme.ink.opacity(model.isWitnessed ? 0 : 1), lineWidth: 1))
            }
            .buttonStyle(.plain)
            .disabled(model.isWitnessed || model.isSaving)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.2), value: model.isWitnessed)
            .accessibilityIdentifier("today.witnessButton")
            .accessibilityHint(model.isWitnessed ? "Already recorded privately on this device" : "Records one private Witness on this device")

            Text(model.isWitnessed ? "PRIVATE RECORD RESTORED" : "ONE PRIVATE WITNESS · NO PUBLIC COUNT")
                .font(AtlasType.technical(8.5, weight: .medium))
                .tracking(1.0)
                .foregroundStyle(AtlasTheme.inkMuted)
            if model.persistenceError != nil {
                Button("RETRY SAVING") { Task { await model.witness() } }
                    .font(AtlasType.technical(10, weight: .bold))
                    .tracking(1.1)
                    .foregroundStyle(AtlasTheme.sepia)
                    .disabled(model.isSaving)
                    .accessibilityLabel("Save error. Retry saving")
            }
        }
    }

    private var loadFailure: some View {
        VStack(spacing: 12) {
            Text("THE BUNDLED PLATE COULD NOT BE READ")
                .font(AtlasType.technical(12, weight: .bold)).tracking(1.2)
            Text("The offline ritual remains unavailable until a reviewed catalog is bundled.")
                .font(.body).multilineTextAlignment(.center).foregroundStyle(AtlasTheme.inkMuted)
        }
        .padding(28).foregroundStyle(AtlasTheme.ink)
    }

    private var dateStamp: String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        return "\(roman(components.day ?? 1)) · \(components.month ?? 1) · \(components.year ?? 2026)"
    }

    private func roman(_ number: Int) -> String {
        let values: [(Int, String)] = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        var value = number
        var output = ""
        for (amount, symbol) in values { while value >= amount { output += symbol; value -= amount } }
        return output
    }
}
