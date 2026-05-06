import SwiftUI

struct AquariumView: View {
    @Bindable var viewModel: HabitsListViewModel
    @State private var selectedHabitID: UUID?
    @State private var showHabitDetails = false

    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: screenHeight * 0.012),
            GridItem(.flexible(), spacing: screenHeight * 0.012),
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String(localized: "Habit Aquarium"))
                .font(AppFont.fredoka(28))
                .foregroundStyle(Color("textColor_1"))
                .padding(.top, screenHeight * 0.009852)

            ZStack(alignment: .bottom) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridColumns, spacing: screenHeight * 0.012) {
                        ForEach(viewModel.habits) { habit in
                            HabitCardView(
                                habit: habit,
                                healthOpacity: viewModel.fishHealthOpacity(habit),
                                isLoggedToday: viewModel.hasLoggedToday(habit),
                                onLogDay: {
                                    viewModel.logDay(for: habit.id)
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedHabitID = habit.id
                                showHabitDetails = true
                            }
                        }
                    }
                    .padding(.top, screenHeight * 0.016)
                    .padding(.bottom, screenHeight * 0.16)
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom, screenHeight*0.0375)
                NavigationLink {
                    AddHabitView(viewModel: viewModel)
                } label: {
                    Image("newHabitButton")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: screenHeight * 0.23)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "New habit"))
                .shadow(color: Color("appColor_1").opacity(0.6), radius: screenHeight * 0.03)
                .padding(.bottom, screenHeight * 0.09)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, screenHeight * 0.025)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showHabitDetails) {
            if let selectedHabitID {
                HabitDetailView(viewModel: viewModel, habitID: selectedHabitID)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ZStack {
            AppBackgroundLayer()
            AquariumView(viewModel: HabitsListViewModel())
        }
    }
}
