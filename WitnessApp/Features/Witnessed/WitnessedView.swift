import SwiftUI
import WitnessCore

/// ACTS — the third tab. Every species ships one vetted conservation act
/// (a real organization, a real door, sources, an honest effort level).
/// This tab is the field ledger of those acts: this week's act up top,
/// the acts of everything witnessed beneath. Deliberately absent, by
/// evidence and doctrine: deadlines, goals, progress bars, points,
/// streaks, and any claim that an act caused an outcome.
struct ActsView: View {
    @ObservedObject var model: AppModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    Text("ACTS")
                        .font(AtlasType.display(32, weight: .semibold))
                    Spacer()
                    Text(countLabel)
                        .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                        .foregroundStyle(AtlasTheme.sepia)
                }

                if let species = model.species {
                    weeklyAct(species)
                }

                ledger

                Text("Every act opens a real door at the organization named, checked against sources before it ships. Witness records attention and acts honestly, and claims no outcome.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)
            }
            .padding(22)
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(AtlasTheme.ink)
        .background(AtlasPaper().ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var countLabel: String {
        let helping = model.helpingRecords.count
        return helping > 0 ? "\(helping) HELPING" : "ONE ACT A WEEK"
    }

    // MARK: - This week's act

    private func weeklyAct(_ species: SpeciesRecord) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("THIS WEEK · FOR THE \(species.commonName.uppercased())")
                .font(AtlasType.technical(9, weight: .bold)).tracking(1.2)
                .foregroundStyle(AtlasTheme.sepia)

            if let asset = species.gallery?.first, let art = UIImage(named: asset) {
                Image(uiImage: art)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .clipped()
                    .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                    .accessibilityHidden(true)
            }

            Text(species.action.title)
                .font(AtlasType.display(22, weight: .semibold))
                .fixedSize(horizontal: false, vertical: true)

            Text(species.action.summary)
                .font(.callout)
                .lineSpacing(4)

            Text("with \(species.action.destinationOrganization)")
                .font(AtlasType.display(15, weight: .regular, italic: true))
                .foregroundStyle(AtlasTheme.sepia)

            Text("\(species.action.effort.uppercased()) · \(species.action.geographicApplicability.uppercased()) · VERIFIED \(species.action.lastVerified)")
                .font(AtlasType.technical(9, weight: .medium)).tracking(0.8)
                .foregroundStyle(AtlasTheme.inkMuted)
                .fixedSize(horizontal: false, vertical: true)

            openButton(for: species, identifier: "acts.weekly.open")
            helpingRow(for: species)
        }
        .padding(16)
        .background(AtlasTheme.paperFresh)
        .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("acts.weekly")
    }

    private func openButton(for species: SpeciesRecord, identifier: String) -> some View {
        Button {
            open(species)
        } label: {
            HStack(spacing: 10) {
                Text("OPEN · \(species.action.destinationOrganization.uppercased())")
                    .font(AtlasType.technical(11, weight: .bold)).tracking(1.2)
                    .lineLimit(1).minimumScaleFactor(0.7)
                Spacer()
                AtlasIconView(icon: .returnMark, size: 15, color: AtlasTheme.paper)
            }
            .foregroundStyle(AtlasTheme.paper)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(AtlasTheme.ink)
            .overlay(
                Rectangle()
                    .strokeBorder(AtlasTheme.paper.opacity(0.35), lineWidth: 1)
                    .padding(3)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(AtlasPressStyle())
        .accessibilityIdentifier(identifier)
        .accessibilityLabel("Open \(species.action.title) at \(species.action.destinationOrganization)")
    }

    @ViewBuilder
    private func helpingRow(for species: SpeciesRecord) -> some View {
        if let helping = model.helpingRecord(for: species.id) {
            HStack(spacing: 8) {
                AtlasIconView(icon: .fieldMark, size: 14, color: AtlasTheme.accentSage)
                Text("HELPING SINCE · \(helping.startedAt.formatted(.dateTime.month(.abbreviated).day()).uppercased())")
                    .font(AtlasType.technical(10, weight: .bold)).tracking(1.0)
                    .foregroundStyle(AtlasTheme.accentSage)
                Spacer()
            }
            .frame(minHeight: 44)
            .accessibilityIdentifier("acts.weekly.helpingSince")
        } else {
            Button {
                Task { await model.startHelping(speciesID: species.id) }
            } label: {
                HStack(spacing: 8) {
                    AtlasIconView(icon: .fieldMark, size: 14, color: AtlasTheme.sepia)
                    Text("I’M HELPING THIS SPECIES")
                        .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                    Spacer()
                }
                .foregroundStyle(AtlasTheme.sepia)
                .padding(.horizontal, 14)
                .frame(maxWidth: .infinity, minHeight: 46)
                .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("acts.weekly.helping")
        }
    }

    // MARK: - The ledger

    private var ledgerRows: [(species: SpeciesRecord, witnessedAt: Date, helping: HelpingRecord?)] {
        model.witnessedCollection.filter { $0.species.id != model.species?.id }
    }

    @ViewBuilder
    private var ledger: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("THE LEDGER")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.2)
                .foregroundStyle(AtlasTheme.sepia)
                .padding(.bottom, 8)
                .accessibilityAddTraits(.isHeader)
            if ledgerRows.isEmpty {
                Text("Witness a species and its act takes a line here — one vetted door for every plate in your cabinet.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)
                    .padding(.vertical, 10)
            } else {
                ForEach(ledgerRows, id: \.species.id) { row in
                    ledgerRow(row.species, helping: row.helping)
                }
            }
        }
    }

    private func ledgerRow(_ species: SpeciesRecord, helping: HelpingRecord?) -> some View {
        Button {
            open(species)
        } label: {
            HStack(spacing: 12) {
                if let asset = species.gallery?.first, let art = UIImage(named: asset) {
                    Image(uiImage: art)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 56)
                        .clipped()
                        .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                        .accessibilityHidden(true)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(species.commonName.uppercased())
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.0)
                        .foregroundStyle(AtlasTheme.sepia)
                    Text(species.action.title)
                        .font(AtlasType.display(16, weight: .medium))
                        .multilineTextAlignment(.leading)
                    Text(helping == nil
                         ? "with \(species.action.destinationOrganization)"
                         : "HELPING SINCE · \(helping!.startedAt.formatted(.dateTime.month(.abbreviated).day()).uppercased())")
                        .font(AtlasType.technical(9, weight: .medium)).tracking(0.7)
                        .foregroundStyle(helping == nil ? AtlasTheme.inkMuted : AtlasTheme.accentSage)
                }
                Spacer()
                AtlasIconView(icon: .returnMark, size: 14, color: AtlasTheme.sepia)
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) { Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1) }
        .accessibilityLabel("\(species.commonName): \(species.action.title), with \(species.action.destinationOrganization)")
    }

    private func open(_ species: SpeciesRecord) {
        guard let url = URL(string: species.action.destinationURL) else { return }
        let speciesID = species.id
        Task.detached { await WitnessSync.shared.logEvent("action_opened", metadata: ["species": speciesID]) }
        openURL(url)
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
                    Text("Witness this week’s plate before leaving a note.")
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
