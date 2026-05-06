import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    let healthOpacity: Double
    let isLoggedToday: Bool
    let onLogDay: () -> Void

    var body: some View {
        VStack(spacing: screenHeight * 0.01) {
            HStack {
                Text(habit.stage.rawValue)
                    .font(AppFont.nunitoBold(13))
                    .foregroundStyle(Color("textColor_1").opacity(0.7))
                    .padding(.horizontal, screenHeight * 0.012)
                    .padding(.vertical, screenHeight * 0.006)
                    .background(Color("appColor_1").opacity(0.22), in: Capsule())

                Spacer()

                HStack(spacing: screenHeight * 0.004) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: screenHeight * 0.013))
                    Text("\(habit.streakDays)")
                        .font(AppFont.nunitoBold(13))
                }
                .foregroundStyle(Color.orange)
                .padding(.horizontal, screenHeight * 0.012)
                .padding(.vertical, screenHeight * 0.006)
                .background(Color.orange.opacity(0.16), in: Capsule())
            }

            Image(habit.stageIconName)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight * 0.072)
                .opacity(healthOpacity)
                .brightness((healthOpacity - 1) * 0.22)
                .shadow(color: Color.black.opacity(0.15), radius: screenHeight * 0.01, y: screenHeight * 0.003)

            Text(habit.title)
                .font(AppFont.nunitoBold(22))
                .foregroundStyle(Color("textColor_1"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text("Day \(habit.streakDays)")
                .font(AppFont.nunitoRegular(16))
                .foregroundStyle(Color("textColor_1").opacity(0.5))

            Button(action: onLogDay) {
                Image(isLoggedToday ? "loggedButton" : "logDayButton")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight * 0.054)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .disabled(isLoggedToday)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, screenHeight * 0.017)
        .padding(.vertical, screenHeight * 0.013)
        .frame(height: ScreenMetrics.habitAquariumCardHeight, alignment: .top)
        .background(Color("appColor_4"), in: RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous)
                .stroke(Color.white.opacity(0.95), lineWidth: screenHeight * 0.0037)
        )
    }
}

#Preview {
    HabitCardView(
        habit: Habit(title: "Morning Run", fishIconName: "Clownfish_1", streakDays: 14),
        healthOpacity: 0.92,
        isLoggedToday: false,
        onLogDay: {}
    )
    .padding()
    .background(AppBackgroundLayer())
}
