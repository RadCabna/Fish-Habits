import SwiftUI

struct HabitRowView: View {
    let habit: Habit

    var body: some View {
        HStack(spacing: screenHeight * 0.015) {
            Image(habit.fishIconName)
                .resizable()
                .scaledToFit()
                .frame(width: screenHeight * 0.04, height: screenHeight * 0.04)
            Text(habit.title)
                .font(AppFont.nunitoBold(17))
                .foregroundStyle(.primary)
            Spacer(minLength: 0)
        }
        .padding(.vertical, screenHeight * 0.004926)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

#Preview("Habit row") {
    List {
        HabitRowView(habit: Habit(title: "Read", fishIconName: "Angelfish_1"))
    }
    .listStyle(.insetGrouped)
}

#Preview("Habit row 2") {
    List {
        HabitRowView(habit: Habit(title: "Walk", fishIconName: "Guppy_1"))
    }
    .listStyle(.insetGrouped)
}
