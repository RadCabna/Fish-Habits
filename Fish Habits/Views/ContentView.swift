import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .aquarium
    @State private var habitsViewModel = HabitsListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundLayer()

                Group {
                    switch selectedTab {
                    case .aquarium:
                        AquariumView(viewModel: habitsViewModel)
                    case .archive:
                        ArchiveView(viewModel: habitsViewModel)
                    case .statistics:
                        StatisticsView(habitsViewModel: habitsViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                if let celebrationID = habitsViewModel.celebrationHabitID,
                   let celebrationHabit = habitsViewModel.habits.first(where: { $0.id == celebrationID }) {
                    ZStack(alignment: .bottom) {
                        Color.black.opacity(0.38)
                            .ignoresSafeArea()
                            .onTapGesture {
                                habitsViewModel.dismissCelebration()
                            }
                            .transition(.opacity)

                        HabitCompletionCelebrationView(
                            habit: celebrationHabit,
                            onArchive: {
                                habitsViewModel.archiveCompletedHabit(habitID: celebrationID)
                                selectedTab = .archive
                            }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(edges: .bottom)
                    .zIndex(20)
                }

                VStack {
                    Spacer()
                    CustomTabBarView(selectedTab: $selectedTab)
                }
                .zIndex(1)
            }
            .dismissKeyboardOnTap()
            .animation(.spring(response: 0.42, dampingFraction: 0.88), value: habitsViewModel.celebrationHabitID)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
