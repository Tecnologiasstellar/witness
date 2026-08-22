import SwiftUI
import WitnessCore

struct WitnessedView: View {
    @ObservedObject var model: AppModel
    @State private var showsSharePreview = false
    @State private var showsReflection = false

    var body: some View {
        Group {
            if let record = model.latestWitnessRecord, let species = model.species {
                witnessedPlate(species: species, date: record.witnessedAt)
            } else {
                emptyState
            }
        }
        .background(AtlasPaper().ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showsSharePreview) {
            if let species = model.species { WitnessSharePreviewSheet(species: species) }
        }
        .sheet(isPresented: $showsReflection) { PrivateReflectionSheet(model: model) }
    }

    private func witnessedPlate(species: SpeciesRecord, date: Date) -> some View {
        GeometryReader { _ in
            ZStack {
                PlateFrame()
                VStack(spacing: 12) {
                    Text("WITNESSED")
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.55)
                        .foregroundStyle(AtlasTheme.sepia)
                    AtlasSeal(date: date)
                    SpecimenPlate(species: species, showsLeaderLabels: false).frame(height: 176)
                    Text(species.commonName.uppercased())
                        .font(AtlasType.display(30, weight: .semibold)).tracking(AtlasType.tracking(0.06, at: 30, dynamicTypeSize: .large))
                    Text(species.scientificName)
                        .font(AtlasType.display(14, italic: true)).foregroundStyle(AtlasTheme.inkMuted)
                    Text("PRIVATE ON-DEVICE RECORD")
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.1)
                        .foregroundStyle(AtlasTheme.inkMuted)
                    Spacer(minLength: 4)
                    Button("LEAVE A NOTE") { showsReflection = true }
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.15)
                        .foregroundStyle(AtlasTheme.sepia).frame(minHeight: 44)
                    Button("SHARE PLATE") { showsSharePreview = true }
                        .font(AtlasType.technical(10, weight: .bold)).tracking(1.15)
                        .foregroundStyle(AtlasTheme.inkMuted).frame(minHeight: 44)
                        .accessibilityIdentifier("witnessed.sharePreviewButton")
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28).padding(.vertical, 18)
            }
        }
        .foregroundStyle(AtlasTheme.ink)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            AtlasIconView(icon: .fieldMark, size: 28)
            Text("NO PRIVATE PLATE YET")
                .font(AtlasType.technical(12, weight: .bold)).tracking(1.2)
            Text("Witness today’s species and its card will remain on this device.")
                .font(.body).multilineTextAlignment(.center).foregroundStyle(AtlasTheme.inkMuted)
        }
        .padding(28).foregroundStyle(AtlasTheme.ink)
    }
}

struct PrivateReflectionSheet: View {
    @ObservedObject var model: AppModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var reflectionFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("PRIVATE NOTE")
                    .font(AtlasType.display(30, weight: .semibold))
                Text("This reflection remains on this device. It is never published by Witness.")
                    .font(.footnote).foregroundStyle(AtlasTheme.inkMuted)
                if model.latestWitnessRecord == nil {
                    Text("Witness today’s plate before leaving a note.")
                        .font(.body).foregroundStyle(AtlasTheme.inkMuted)
                    Spacer()
                } else {
                    TextEditor(text: $model.reflectionDraft)
                        .focused($reflectionFocused).scrollContentBackground(.hidden)
                        .padding(10).frame(minHeight: 180)
                        .background(AtlasTheme.paperFresh)
                        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                        .accessibilityIdentifier("witnessed.reflectionEditor")
                        .accessibilityLabel("Private reflection")
                        .onChange(of: model.reflectionDraft) { _, newValue in
                            if newValue.count > FileWitnessRepository.reflectionCharacterLimit {
                                model.reflectionDraft = String(newValue.prefix(FileWitnessRepository.reflectionCharacterLimit))
                            }
                        }
                    HStack {
                        Text("\(model.reflectionDraft.count)/\(FileWitnessRepository.reflectionCharacterLimit)")
                            .font(AtlasType.technical(9)).foregroundStyle(AtlasTheme.inkMuted)
                        Spacer()
                        Button(model.isSaving ? "SAVING" : "SAVE NOTE") {
                            reflectionFocused = false
                            Task { await model.saveReflection(); if model.persistenceError == nil { dismiss() } }
                        }
                        .font(AtlasType.technical(11, weight: .bold)).tracking(1.1)
                        .accessibilityIdentifier("witnessed.saveReflectionButton")
                        .disabled(model.isSaving)
                    }
                    if let error = model.persistenceError {
                        Text(error).font(.caption).foregroundStyle(AtlasTheme.sepia)
                    }
                }
            }
            .padding(22).foregroundStyle(AtlasTheme.ink)
            .background(AtlasPaper().ignoresSafeArea())
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("CLOSE") { dismiss() }.font(AtlasType.technical(10, weight: .bold)) } }
        }
    }
}

private struct AtlasSeal: View {
    let date: Date
    var body: some View {
        ZStack {
            Circle().stroke(AtlasTheme.sepia, lineWidth: 1).frame(width: 64, height: 64)
            Circle().stroke(AtlasTheme.ruleSoft, lineWidth: 1).frame(width: 52, height: 52)
            Text(date.formatted(.dateTime.day().month(.abbreviated)).uppercased())
                .font(AtlasType.technical(9, weight: .bold)).tracking(0.8)
                .multilineTextAlignment(.center)
        }
        .accessibilityLabel("Witnessed on \(date.formatted(date: .long, time: .omitted))")
    }
}
