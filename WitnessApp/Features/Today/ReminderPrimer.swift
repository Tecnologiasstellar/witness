import SwiftUI

/// The reminder-time primer, shown once inside the witnessed reveal after the
/// first completed witness (D-008: value before permissions). The iOS
/// permission prompt fires only after the user picks a time.
struct ReminderPrimer: View {
    @ObservedObject private var reminders = ReminderService.shared
    @State private var isChoosingTime = false
    @State private var enabledHere = false
    @State private var customTime = Calendar.current.date(from: DateComponents(hour: 8)) ?? .now

    var body: some View {
        // Renders once, right after the first witness; disappears for good
        // after any answer. Confirmation shows only in the enabling session.
        if enabledHere {
            confirmation
        } else if !reminders.primerAnswered {
            primer
        }
    }

    private var confirmation: some View {
        HStack(spacing: 8) {
            AtlasIconView(icon: .fieldMark, size: 14, color: AtlasTheme.accentSage)
            Text("REMINDER SET · \(reminders.timeLabel.uppercased()) · CHANGE IT IN THE INDEX")
                .font(AtlasType.technical(9, weight: .bold)).tracking(1.0)
                .foregroundStyle(AtlasTheme.inkMuted)
            Spacer()
        }
        .padding(14)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
    }

    private func enable(hour: Int, minute: Int) {
        Task {
            await reminders.enable(hour: hour, minute: minute)
            withAnimation { enabledHere = reminders.isEnabled }
        }
    }

    private var primer: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RETURN TOMORROW")
                .font(AtlasType.technical(9, weight: .bold)).tracking(1.2)
                .foregroundStyle(AtlasTheme.sepia)
            Text("A new species arrives each morning. Choose a time and Witness will remind you.")
                .font(AtlasType.display(16))
                .lineSpacing(6)

            HStack(spacing: 8) {
                ForEach(ReminderService.presets, id: \.label) { preset in
                    Button {
                        enable(hour: preset.hour, minute: preset.minute)
                    } label: {
                        Text(preset.label)
                            .font(AtlasType.technical(10, weight: .bold)).tracking(0.9)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .overlay(Rectangle().stroke(AtlasTheme.sepia.opacity(0.5), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
            .foregroundStyle(AtlasTheme.sepia)

            if isChoosingTime {
                HStack {
                    DatePicker("Reminder time", selection: $customTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    Spacer()
                    Button {
                        let parts = Calendar.current.dateComponents([.hour, .minute], from: customTime)
                        enable(hour: parts.hour ?? 8, minute: parts.minute ?? 0)
                    } label: {
                        Text("SET")
                            .font(AtlasType.technical(10, weight: .bold)).tracking(1.1)
                            .padding(.horizontal, 18)
                            .frame(minHeight: 44)
                            .overlay(Rectangle().stroke(AtlasTheme.sepia.opacity(0.5), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(AtlasTheme.sepia)
                }
            }

            HStack {
                Button {
                    withAnimation { isChoosingTime.toggle() }
                } label: {
                    Text("CHOOSE A TIME")
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.0)
                        .frame(minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(AtlasTheme.inkMuted)
                Spacer()
                Button {
                    withAnimation { reminders.markPrimerAnswered() }
                } label: {
                    Text("NOT NOW")
                        .font(AtlasType.technical(9, weight: .bold)).tracking(1.0)
                        .frame(minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(AtlasTheme.inkMuted)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AtlasTheme.paperFresh)
        .overlay(Rectangle().stroke(AtlasTheme.ruleSoft, lineWidth: 1))
        .accessibilityIdentifier("today.reminderPrimer")
    }
}
