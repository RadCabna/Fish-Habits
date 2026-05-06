import SwiftUI

struct StatisticsView: View {
    @Bindable var habitsViewModel: HabitsListViewModel
    @State private var period: StatisticsPeriod = .month
    @State private var selectedGrowthAxisLabel: String?

    private let statYellow = Color(red: 1, green: 0.86, blue: 0.22)

    private var habitsCreated: Int {
        StatisticsAggregation.habitsCreatedCount(active: habitsViewModel.habits, archived: habitsViewModel.archivedFish)
    }

    private var longestStreak: Int {
        StatisticsAggregation.longestStreakDays(among: habitsViewModel.habits)
    }

    private var fishGrown: Int {
        StatisticsAggregation.fishGrownCount(archived: habitsViewModel.archivedFish)
    }

    private var monthActivity: [(index: Int, count: Int)] {
        StatisticsAggregation.activityByDayLast30(habits: habitsViewModel.habits)
    }

    private var yearActivity: [(monthKey: String, count: Int)] {
        StatisticsAggregation.activityByMonthInYear(habits: habitsViewModel.habits)
    }

    private var growthRows: [StatisticsAggregation.GrowthBarRow] {
        StatisticsAggregation.growthRows(habits: habitsViewModel.habits)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: screenHeight * 0.018) {
                Text(String(localized: "Statistics"))
                    .font(AppFont.fredoka(28))
                    .foregroundStyle(Color("textColor_1"))
                    .padding(.top, screenHeight * 0.009852)

                periodToggle

                summaryTiles

                StatisticsActivityChartCard(
                    period: period,
                    monthPoints: monthActivity,
                    yearPoints: yearActivity
                )

                StatisticsGrowthChartCard(
                    rows: growthRows,
                    selectedAxisLabel: $selectedGrowthAxisLabel
                )
            }
            .padding(.horizontal, screenHeight * 0.024631)
            .padding(.bottom, screenHeight * 0.14)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onChange(of: period) { _, _ in
            selectedGrowthAxisLabel = nil
        }
    }

    private var periodToggle: some View {
        let buttonHeight = screenHeight * 0.046
        let corner = screenHeight * 0.08
        return HStack(spacing: screenHeight * 0.012) {
            periodButton(
                isSelected: period == .month,
                activeAsset: "monthButtonOn",
                inactiveTitleKey: String(localized: "Month"),
                buttonHeight: buttonHeight,
                corner: corner
            ) {
                period = .month
            }

            periodButton(
                isSelected: period == .year,
                activeAsset: "yearButtonOn",
                inactiveTitleKey: String(localized: "Year"),
                buttonHeight: buttonHeight,
                corner: corner
            ) {
                period = .year
            }
        }
    }

    private func periodButton(
        isSelected: Bool,
        activeAsset: String,
        inactiveTitleKey: String,
        buttonHeight: CGFloat,
        corner: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack {
                if !isSelected {
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .fill(Color("appColor_4"))
                        .overlay(
                            RoundedRectangle(cornerRadius: corner, style: .continuous)
                                .stroke(Color.white.opacity(0.92), lineWidth: screenHeight * 0.002)
                        )
                }
                if isSelected {
                    Image(activeAsset)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text(inactiveTitleKey)
                        .font(AppFont.nunitoBold(13))
                        .foregroundStyle(Color(.textColor1).opacity(0.6))
                        .padding(.bottom, screenHeight*0.003)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var summaryTiles: some View {
        HStack(spacing: screenHeight * 0.01) {
            statisticTile(big: "\(habitsCreated)", caption: String(localized: "Habits created"))
            statisticTile(big: longestStreak == 0 ? "0" : "\(longestStreak)d", caption: String(localized: "Longest streak"))
            statisticTile(big: "\(fishGrown)", caption: String(localized: "Fish grown"))
        }
    }

    private func statisticTile(big: String, caption: String) -> some View {
        ZStack {
            Image("statisticRectangle")
                .resizable()
                .scaledToFit()

            VStack(spacing: screenHeight * 0.005) {
                Text(big)
                    .font(AppFont.fredoka(30))
                    .foregroundStyle(statYellow)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(caption)
                    .font(AppFont.nunitoRegular(13))
                    .foregroundStyle(Color("textColor_1").opacity(0.6))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
//                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: screenHeight*0.06)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, screenHeight * 0.02)
            .padding(.vertical, screenHeight * 0.014)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        AppBackgroundLayer()
        StatisticsView(habitsViewModel: HabitsListViewModel())
    }
}
