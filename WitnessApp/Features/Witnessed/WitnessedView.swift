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

    // MARK: - The field journal
    //
    // What separates a living feed from a collection (per the Mobbin
    // evidence) is a visible time spine, mixed entry weights, and type
    // microlabels — not more cards. Every line below is honest data the
    // device already holds: the user's own witnessed and helping history,
    // with each species' open door woven into its entry.

    private struct JournalDay: Identifiable {
        let id: String
        let header: String
        let entries: [JournalLine]
    }

    private struct JournalLine: Identifiable {
        let id: String
        let label: String
        let stamp: String
        let species: SpeciesRecord
        let text: String
        let detail: String
        let isHelping: Bool
        let showsThumb: Bool
    }

    private var journalDays: [JournalDay] {
        var lines: [(date: Date, line: JournalLine)] = []
        // Helping commitments stand in the journal even before (or without)
        // a witness of that species — the hero's own act, for instance.
        let witnessedIDs = Set(model.witnessedCollection.map(\.species.id))
        for helping in model.helpingRecords where !witnessedIDs.contains(helping.speciesID) {
            guard let species = model.catalog.first(where: { $0.id == helping.speciesID }) else { continue }
            lines.append((helping.startedAt, JournalLine(
                id: "helping.\(species.id)",
                label: "TOOK UP THE ACT",
                stamp: helping.startedAt.formatted(.dateTime.month(.abbreviated).day()).uppercased(),
                species: species,
                text: "For the \(species.commonName.lowercased()), with \(species.action.destinationOrganization).",
                detail: "",
                isHelping: true,
                showsThumb: false
            )))
        }
        for row in model.witnessedCollection {
            let stamp = row.witnessedAt.formatted(.dateTime.month(.abbreviated).day()).uppercased()
            lines.append((row.witnessedAt, JournalLine(
                id: "witness.\(row.species.id)",
                label: "WITNESSED",
                stamp: stamp,
                species: row.species,
                text: row.species.commonName,
                detail: "One door stands open: \(row.species.action.title) — with \(row.species.action.destinationOrganization).",
                isHelping: false,
                showsThumb: true
            )))
            if let helping = row.helping {
                lines.append((helping.startedAt, JournalLine(
                    id: "helping.\(row.species.id)",
                    label: "TOOK UP THE ACT",
                    stamp: helping.startedAt.formatted(.dateTime.month(.abbreviated).day()).uppercased(),
                    species: row.species,
                    text: "For the \(row.species.commonName.lowercased()), with \(row.species.action.destinationOrganization).",
                    detail: "",
                    isHelping: true,
                    showsThumb: false
                )))
            }
        }
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: lines) { calendar.startOfDay(for: $0.date) }
        return grouped.keys.sorted(by: >).map { day in
            let header = calendar.isDate(day, equalTo: Date(), toGranularity: .weekOfYear)
                ? "THIS WEEK"
                : day.formatted(.dateTime.month(.wide).day()).uppercased()
            let entries = grouped[day]!.sorted { $0.date > $1.date }.map(\.line)
            return JournalDay(id: "\(day.timeIntervalSince1970)", header: header, entries: entries)
        }
    }

    @ViewBuilder
    private var ledger: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("FIELD JOURNAL")
                .font(AtlasType.technical(10, weight: .bold)).tracking(1.2)
                .foregroundStyle(AtlasTheme.sepia)
                .padding(.bottom, 10)
                .accessibilityAddTraits(.isHeader)
            let days = journalDays
            if days.isEmpty {
                Text("Witness a species and this journal begins — every plate adds its open door, and every act you take up leaves a line.")
                    .font(.footnote)
                    .foregroundStyle(AtlasTheme.inkMuted)
                    .lineSpacing(3)
                    .padding(.vertical, 10)
            } else {
                ForEach(days) { day in
                    dayHeader(day.header)
                    ForEach(day.entries) { line in
                        journalRow(line)
                    }
                }
            }
        }
    }

    private func dayHeader(_ title: String) -> some View {
        HStack(spacing: 10) {
            Text(title)
                .font(AtlasType.display(15, weight: .semibold, italic: true))
                .foregroundStyle(AtlasTheme.ink)
            Rectangle().fill(AtlasTheme.ruleSoft).frame(height: 1)
        }
        .padding(.top, 14)
        .padding(.bottom, 6)
        .accessibilityAddTraits(.isHeader)
    }

    /// One journal line on the time rail: node dot, microlabel + stamp,
    /// then an entry whose weight varies by type — the heterogeneity is
    /// what makes it read as a feed instead of a shelf.
    private func journalRow(_ line: JournalLine) -> some View {
        Button {
            open(line.species)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 0) {
                    Circle()
                        .fill(line.isHelping ? AtlasTheme.accentSage : AtlasTheme.sepia)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Rectangle().fill(AtlasTheme.ruleSoft).frame(width: 1)
                }
                .frame(width: 10)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(line.label)
                            .font(AtlasType.technical(8.5, weight: .bold)).tracking(1.2)
                            .foregroundStyle(line.isHelping ? AtlasTheme.accentSage : AtlasTheme.sepia)
                        Spacer()
                        Text(line.stamp)
                            .font(AtlasType.technical(8.5, weight: .medium)).tracking(0.8)
                            .foregroundStyle(AtlasTheme.inkMuted)
                    }
                    HStack(alignment: .top, spacing: 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(line.text)
                                .font(line.isHelping
                                      ? AtlasType.display(15, weight: .regular, italic: true)
                                      : AtlasType.display(18, weight: .medium))
                                .multilineTextAlignment(.leading)
                            if !line.detail.isEmpty {
                                Text(line.detail)
                                    .font(.footnote)
                                    .foregroundStyle(AtlasTheme.inkMuted)
                                    .lineSpacing(3)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        Spacer(minLength: 0)
                        if line.showsThumb, let asset = line.species.gallery?.first, let art = UIImage(named: asset) {
                            Image(uiImage: art)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 42, height: 54)
                                .clipped()
                                .overlay(Rectangle().stroke(AtlasTheme.ruleEdge, lineWidth: 1))
                                .accessibilityHidden(true)
                        } else {
                            AtlasIconView(icon: .returnMark, size: 13, color: AtlasTheme.sepia)
                                .padding(.top, 2)
                        }
                    }
                }
            }
            .padding(.bottom, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(line.label): \(line.text). \(line.detail) Opens the organization's page.")
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
