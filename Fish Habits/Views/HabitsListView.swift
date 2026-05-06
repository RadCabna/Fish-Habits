import SwiftUI

struct HabitsListView: View {
    @Bindable var viewModel: HabitsListViewModel

    var body: some View {
        Group {
            if viewModel.habits.isEmpty {
                ContentUnavailableView(
                    String(localized: "No habits yet"),
                    systemImage: "fish",
                    description: Text(String(localized: "Add a small habit and keep the streak going."))
                )
                .frame(minHeight: screenHeight * 0.45)
            } else {
                List {
                    Section {
                        ForEach(viewModel.habits) { habit in
                            HabitRowView(habit: habit)
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(String(localized: "Fish Habits"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    AddHabitView(viewModel: viewModel)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .accessibilityLabel(String(localized: "Add habit"))
                }
            }
        }
    }
}

#Preview("Habits list") {
    NavigationStack {
        HabitsListView(viewModel: HabitsListViewModel())
    }
}

#Preview("Habits list, empty") {
    let vm = HabitsListViewModel()
    vm.habits = []
    return NavigationStack {
        HabitsListView(viewModel: vm)
    }
}
