import SwiftUI
import UIKit

struct HabitDetailView: View {
    @Bindable var viewModel: HabitsListViewModel
    let habitID: UUID

    @Environment(\.dismiss) private var dismiss
    @State private var selectedEntryID: UUID?
    @State private var noteDraft: String = ""
    @State private var showNoteSheet = false
    @State private var keyboardHeight: CGFloat = 0
    private var keyboardLift: CGFloat { screenHeight * 0.34 }

    private var habit: Habit? {
        viewModel.habits.first(where: { $0.id == habitID })
    }

    var body: some View {
        ZStack {
            AppBackgroundLayer()

            if let habit {
                VStack(alignment: .leading, spacing: screenHeight * 0.02) {
                    fishPanel(habit: habit)
                        .padding(.horizontal, screenHeight * 0.02)
                    progressPanel(habit: habit)
                    historySection(habit: habit)
                        .padding(.horizontal, screenHeight * 0.02)
                }
                .padding(.top, screenHeight * 0.018)
                .padding(.bottom, screenHeight * 0.03)
            }

            if showNoteSheet, let habit, let entry = habit.logEntries.first(where: { $0.id == selectedEntryID }) {
                Color.black.opacity(0.38)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                            showNoteSheet = false
                        }
                    }

                VStack {
                    Spacer()
                    AddLogNoteSheetView(
                        entryDate: entry.date,
                        noteText: $noteDraft,
                        onSave: {
                            viewModel.updateLogNote(habitID: habitID, entryID: entry.id, note: noteDraft)
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                                showNoteSheet = false
                            }
                        },
                        onClose: {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                                showNoteSheet = false
                            }
                        }
                    )
                    .frame(height: screenHeight * 0.45)
                    .offset(y: -keyboardHeight)
                    .padding(.horizontal, screenHeight * 0.01)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.86), value: showNoteSheet)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            guard showNoteSheet else { return }
            withAnimation(.easeOut(duration: 0.2)) {
                keyboardHeight = keyboardLift
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.2)) {
                keyboardHeight = 0
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: screenHeight * 0.012) {
                    Button(action: { dismiss() }) {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenHeight * 0.052, height: screenHeight * 0.052)
                    }
                    .buttonStyle(.plain)

                    Text(habit?.title ?? "")
                        .font(AppFont.fredoka(26))
                        .foregroundStyle(Color("textColor_1"))
                }
            }
        }
        .onAppear {
            viewModel.ensureTodayLogEntry(for: habitID)
        }
    }

    private func fishPanel(habit: Habit) -> some View {
        VStack {
            Image(habit.stageIconName)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight * 0.14)
                .shadow(color: Color.black.opacity(0.2), radius: screenHeight * 0.02, y: screenHeight * 0.008)
                .opacity(viewModel.fishHealthOpacity(habit))
        }
        .frame(maxWidth: .infinity)
        .frame(height: screenHeight * 0.24)
        .background(Color.white.opacity(0.28), in: RoundedRectangle(cornerRadius: screenHeight * 0.03, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.03, style: .continuous)
                .stroke(Color.white.opacity(0.75), lineWidth: screenHeight * 0.0018)
        )
    }

    private func progressPanel(habit: Habit) -> some View {
        let steps: [(stage: Habit.Stage, title: String, subtitle: String, asset: String)] = [
            (.egg, "Egg", "Day 0", baseAsset(habit: habit, suffix: "_1")),
            (.fry, "Fry", "Day 1-6", baseAsset(habit: habit, suffix: "_2")),
            (.adult, "Adult", "Day 7-29", baseAsset(habit: habit, suffix: "_3")),
            (.spawn, "Spawn", "Day 30", baseAsset(habit: habit, suffix: "_3")),
        ]
        let circleDiameter = screenHeight * 0.066
        let iconDiameter = screenHeight * 0.035

        return VStack(spacing: screenHeight * 0.01) {
            GeometryReader { geo in
                let connectorWidth = max(screenHeight * 0.035, (geo.size.width - circleDiameter * 4) / 3)
                HStack(spacing: 0) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        let reached = isReached(step.stage, by: habit.stage)
                        let isCurrent = habit.stage == step.stage
                        Circle()
                            .fill(Color("appColor_1").opacity(reached ? 0.9 : 0.2))
                            .frame(width: circleDiameter, height: circleDiameter)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.75), lineWidth: screenHeight * 0.0018)
                            )
                            .overlay {
                                Image(step.asset)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: iconDiameter, height: iconDiameter)
                                    .opacity(reached ? 1 : 0.3)
                            }
                            .shadow(color: Color("appColor_1").opacity(isCurrent ? 0.35 : 0), radius: screenHeight * 0.012)

                        if index < steps.count - 1 {
                            let nextReached = isReached(steps[index + 1].stage, by: habit.stage)
                            Rectangle()
                                .fill(Color("appColor_1").opacity(nextReached ? 0.45 : 0.12))
                                .frame(width: connectorWidth, height: screenHeight * 0.003)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(height: circleDiameter)

            HStack(spacing: 0) {
                ForEach(steps, id: \.stage) { step in
                    let reached = isReached(step.stage, by: habit.stage)
                    VStack(spacing: screenHeight * 0.004) {
                        Text(LocalizedStringKey(step.title))
                            .font(AppFont.nunitoBold(14))
                            .foregroundStyle(Color("textColor_1").opacity(reached ? 0.95 : 0.45))
                        Text(LocalizedStringKey(step.subtitle))
                            .font(AppFont.nunitoRegular(12))
                            .foregroundStyle(Color("textColor_1").opacity(reached ? 0.7 : 0.35))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, screenHeight * 0.02)
        .padding(.vertical, screenHeight * 0.016)
        .frame(maxWidth: .infinity)
        .frame(height: screenHeight * 0.2)
        .background(Color.white.opacity(0.38))
        .overlay(
            Rectangle()
                .stroke(Color.white.opacity(0.75), lineWidth: screenHeight * 0.0018)
        )
    }

    private func isReached(_ step: Habit.Stage, by current: Habit.Stage) -> Bool {
        rank(of: step) <= rank(of: current)
    }

    private func rank(of stage: Habit.Stage) -> Int {
        switch stage {
        case .egg: 0
        case .fry: 1
        case .adult: 2
        case .spawn: 3
        }
    }

    private func historySection(habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.012) {
            HStack {
                Text(String(localized: "Log History"))
                    .font(AppFont.fredoka(22))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(habit.logEntries.count) entries")
                    .font(AppFont.nunitoRegular(16))
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            if habit.logEntries.isEmpty {
                RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous)
                    .fill(Color.white.opacity(0.28))
                    .frame(height: screenHeight * 0.085)
                    .overlay(
                        RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous)
                            .stroke(Color.white.opacity(0.75), lineWidth: screenHeight * 0.0018)
                    )
                    .overlay {
                        Text(String(localized: "No entries yet. Log your first day!"))
                            .font(AppFont.nunitoRegular(20))
                            .foregroundStyle(Color("textColor_1").opacity(0.45))
                    }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: screenHeight * 0.009) {
                        ForEach(habit.logEntries) { entry in
                            Button {
                                selectedEntryID = entry.id
                                noteDraft = entry.note
                                withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                                    showNoteSheet = true
                                }
                            } label: {
                                HStack(spacing: screenHeight * 0.014) {
                                    Text(shortDate(entry.date))
                                        .font(AppFont.nunitoRegular(16))
                                        .foregroundStyle(Color("textColor_1").opacity(0.72))
                                        .frame(width: screenHeight * 0.12, alignment: .leading)

                                    Text(entry.note.isEmpty ? String(localized: "Tap to add note...") : entry.note)
                                        .font(AppFont.nunitoRegular(16))
                                        .foregroundStyle(Color("textColor_1").opacity(entry.note.isEmpty ? 0.45 : 0.82))
                                        .modifier(EntryItalicModifier(isEmpty: entry.note.isEmpty))
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Image(systemName: "arrow.up.forward.square")
                                        .font(.system(size: screenHeight * 0.019))
                                        .foregroundStyle(Color("textColor_1").opacity(0.42))
                                }
                                .padding(.horizontal, screenHeight * 0.018)
                                .frame(maxWidth: .infinity)
                                .frame(height: screenHeight * 0.06)
                                .background(Color.white.opacity(0.28), in: RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                                        .stroke(Color.white.opacity(0.75), lineWidth: screenHeight * 0.0018)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxHeight: screenHeight * 0.28)
            }
        }
    }

    private func shortDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "EEE, MMM d"
        return f.string(from: date)
    }

    private func baseAsset(habit: Habit, suffix: String) -> String {
        let base = habit.fishIconName.replacingOccurrences(of: "_1", with: "")
        return "\(base)\(suffix)"
    }
}

private struct EntryItalicModifier: ViewModifier {
    let isEmpty: Bool

    func body(content: Content) -> some View {
        if isEmpty {
            content.italic()
        } else {
            content
        }
    }
}

#Preview {
    let vm = HabitsListViewModel()
    vm.habits = [
        Habit(title: "Morning Run", fishIconName: "Clownfish_1", streakDays: 8, logEntries: [
            Habit.LogEntry(date: .now, note: ""),
            Habit.LogEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now, note: "Ran 5km"),
        ])
    ]
    return NavigationStack {
        HabitDetailView(viewModel: vm, habitID: vm.habits[0].id)
    }
}
