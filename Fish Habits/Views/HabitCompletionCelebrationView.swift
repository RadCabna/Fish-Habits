import SwiftUI

struct HabitCompletionCelebrationView: View {
    let habit: Habit
    let onArchive: () -> Void

    private let accentYellow = Color(red: 1, green: 0.84, blue: 0.15)
    private let titleOutline = Color(red: 0.03, green: 0.08, blue: 0.22)

    private var sheetHeight: CGFloat { screenHeight * 0.58 }
    private var topCorner: CGFloat { screenHeight * 0.028 }

    var body: some View {
        VStack(spacing: 0) {
            heroBlock
                .frame(height: sheetHeight * 0.36)

            VStack(spacing: screenHeight * 0.014) {
                habitCompleteOutlinedTitle

                Text(String(localized: "New species unlocked!"))
                    .font(AppFont.nunitoRegular(17))
                    .foregroundStyle(Color(red: 0.42, green: 0.62, blue: 0.92))

                speciesDetailCard

                Spacer(minLength: screenHeight * 0.012)

                Button(action: onArchive) {
                    Image("toArchiveButton")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: screenHeight * 0.076)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, screenHeight * 0.026)
            .padding(.top, screenHeight * 0.01)
            .padding(.bottom, screenHeight * 0.028)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity)
        .frame(height: sheetHeight)
        .background(modalFill)
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: RectangleCornerRadii(
                    topLeading: topCorner,
                    bottomLeading: 0,
                    bottomTrailing: 0,
                    topTrailing: topCorner
                ),
                style: .continuous
            )
        )
        .overlay(
            UnevenRoundedRectangle(
                cornerRadii: RectangleCornerRadii(
                    topLeading: topCorner,
                    bottomLeading: 0,
                    bottomTrailing: 0,
                    topTrailing: topCorner
                ),
                style: .continuous
            )
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.95),
                        Color.white.opacity(0.35),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: screenHeight * 0.0022
            )
        )
        .shadow(color: Color.black.opacity(0.22), radius: screenHeight * 0.02, y: -screenHeight * 0.008)
        .onTapGesture {}
    }

    private var modalFill: some View {
        LinearGradient(
            colors: [
                Color(red: 0.97, green: 0.99, blue: 1),
                Color(red: 0.88, green: 0.94, blue: 0.99),
                Color(red: 0.78, green: 0.88, blue: 0.96),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var heroBlock: some View {
        ZStack {
            confettiField

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            accentYellow.opacity(0.55),
                            accentYellow.opacity(0.12),
                            Color.clear,
                        ],
                        center: .center,
                        startRadius: screenHeight * 0.012,
                        endRadius: screenHeight * 0.11
                    )
                )
                .frame(width: screenHeight * 0.2, height: screenHeight * 0.2)

            Image(habit.stageIconName)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight * 0.14)
                .shadow(color: Color.black.opacity(0.12), radius: screenHeight * 0.008, y: screenHeight * 0.004)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, screenHeight * 0.018)
    }

    private var confettiField: some View {
        ZStack {
            ForEach(confettiSpecs.indices, id: \.self) { i in
                let s = confettiSpecs[i]
                RoundedRectangle(cornerRadius: screenHeight * 0.003, style: .continuous)
                    .fill(s.color)
                    .frame(width: screenHeight * s.size, height: screenHeight * s.size)
                    .rotationEffect(.degrees(s.angle))
                    .offset(x: s.dx * screenWidth * 0.42, y: s.dy * sheetHeight * 0.22)
            }
        }
        .allowsHitTesting(false)
    }

    private var confettiSpecs: [(dx: CGFloat, dy: CGFloat, angle: Double, size: CGFloat, color: Color)] {
        [
            (-0.52, -0.55, 18, 0.014, accentYellow),
            (0.48, -0.62, -24, 0.012, Color(red: 0.45, green: 0.78, blue: 1)),
            (-0.35, -0.82, 42, 0.011, Color.orange.opacity(0.95)),
            (0.62, -0.48, -12, 0.013, accentYellow),
            (-0.72, -0.35, 33, 0.01, Color("appColor_1")),
            (0.28, -0.88, -38, 0.012, Color.orange.opacity(0.88)),
            (-0.22, -0.58, 8, 0.011, Color(red: 0.5, green: 0.82, blue: 1)),
            (0.78, -0.72, 22, 0.01, accentYellow),
            (-0.58, -0.72, -18, 0.013, Color("appColor_1").opacity(0.85)),
            (0.08, -0.52, 55, 0.012, Color.orange.opacity(0.9)),
            (-0.88, -0.58, -42, 0.011, Color(red: 0.42, green: 0.72, blue: 0.98)),
            (0.52, -0.28, 14, 0.012, accentYellow),
            (-0.08, -0.78, -28, 0.01, Color("appColor_1")),
            (0.68, -0.38, 36, 0.011, Color(red: 0.48, green: 0.76, blue: 1)),
        ]
    }

    private var habitCompleteOutlinedTitle: some View {
        let title = String(localized: "Habit Complete!")
        let spread = screenHeight * 0.003
        let outlineGrid: [(Int, Int)] = [
            (-1, -1), (-1, 0), (-1, 1),
            (0, -1), (0, 1),
            (1, -1), (1, 0), (1, 1),
        ]
        return ZStack {
            ForEach(Array(outlineGrid.enumerated()), id: \.offset) { _, pair in
                Text(title)
                    .font(AppFont.fredoka(30))
                    .foregroundStyle(titleOutline)
                    .offset(x: CGFloat(pair.0) * spread, y: CGFloat(pair.1) * spread)
            }
            Text(title)
                .font(AppFont.fredoka(30))
                .foregroundStyle(accentYellow)
        }
        .shadow(color: titleOutline.opacity(0.35), radius: 0, x: screenHeight * 0.0025, y: screenHeight * 0.0025)
        .multilineTextAlignment(.center)
    }

    private var speciesDetailCard: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.007) {
            Text(FishEggCatalog.displayName(for: habit.fishIconName))
                .font(AppFont.nunitoBold(21))
                .foregroundStyle(Color.orange)

            Text(String(format: String(localized: "from «%@»"), habit.title))
                .font(AppFont.nunitoRegular(15))
                .foregroundStyle(Color(red: 0.38, green: 0.44, blue: 0.52))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, screenHeight * 0.022)
        .padding(.vertical, screenHeight * 0.018)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                .fill(Color(red: 1, green: 0.94, blue: 0.72))
                .shadow(color: accentYellow.opacity(0.15), radius: screenHeight * 0.012, y: screenHeight * 0.004)
        )
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                .stroke(Color.white.opacity(0.65), lineWidth: screenHeight * 0.0012)
        )
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        AppBackgroundLayer()
        Color.black.opacity(0.38)
            .ignoresSafeArea()
        HabitCompletionCelebrationView(
            habit: Habit(title: String(localized: "Morning Run"), fishIconName: "Clownfish_1", streakDays: 2),
            onArchive: {}
        )
    }
    .ignoresSafeArea(edges: .bottom)
}
