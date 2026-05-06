import SwiftUI

struct StatisticsGrowthChartCard: View {
    let rows: [StatisticsAggregation.GrowthBarRow]
    @Binding var selectedAxisLabel: String?

    private var sh: CGFloat { ScreenMetrics.screenHeight }
    private var chartBlue: Color { Color("appColor_1") }
    private var tooltipFill: Color { Color("appColor_4") }
    private var tooltipStroke: Color { Color("appColor_1") }
    private var highlightYellow: Color { Color(red: 1, green: 0.88, blue: 0.22) }
    /// Matches spacing between bar columns in the plot `HStack`.
    private var barColumnSpacing: CGFloat { sh * 0.008 }

    private var yTop: Int {
        let maxDays = max(rows.map(\.daysLogged).max() ?? 0, 1)
        return StatisticsAggregation.chartCeiling(maxValue: maxDays, steps: 15)
    }

    private var yTicksAscending: [Int] {
        let top = max(yTop, 1)
        if top <= 2 {
            return [0, top]
        }
        let mid = max(1, top / 2)
        return Array(Set([0, mid, top])).sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: sh * 0.012) {
            Text(String(localized: "Growth by Habit"))
                .font(AppFont.nunitoBold(17))
                .foregroundStyle(Color("textColor_1"))

            if rows.isEmpty {
                Text(String(localized: "Create habits and log days to see this chart."))
                    .font(AppFont.nunitoRegular(14))
                    .foregroundStyle(Color("textColor_1").opacity(0.45))
                    .frame(maxWidth: .infinity)
                    .frame(height: sh * 0.2)
            } else {
                customGrowthChart
                    .frame(height: sh * 0.26)
            }
        }
        .padding(.horizontal, sh * 0.018)
        .padding(.vertical, sh * 0.016)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: sh * 0.024, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: sh * 0.024, style: .continuous)
                .stroke(Color.white.opacity(0.78), lineWidth: sh * 0.0018)
        )
    }

    private var customGrowthChart: some View {
        let axisLabelWidth = sh * 0.038
        let plotHeight = sh * 0.19
        let spacing = sh * 0.006

        return HStack(alignment: .top, spacing: spacing) {
            yAxisLabels(plotHeight: plotHeight)
                .frame(width: axisLabelWidth, height: plotHeight)

            VStack(alignment: .leading, spacing: sh * 0.005) {
                GeometryReader { geo in
                    let plotW = geo.size.width
                    ZStack(alignment: .bottomLeading) {
                        horizontalGrid(plotWidth: plotW, plotHeight: plotHeight)
                            .allowsHitTesting(false)

                        HStack(alignment: .bottom, spacing: barColumnSpacing) {
                            ForEach(rows) { row in
                                barCell(row: row, plotHeight: plotHeight, columnWidth: plotWidthPerColumn(totalWidth: plotW))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(width: plotW, height: plotHeight, alignment: .bottom)

                        if let label = selectedAxisLabel,
                           let row = rows.first(where: { $0.axisLabel == label }),
                           let idx = rows.firstIndex(where: { $0.axisLabel == label }) {
                            let barH = barHeight(daysLogged: row.daysLogged, plotHeight: plotHeight)
                            let barTop = plotHeight - barH
                            let tooltipW = min(plotW * 0.62, sh * 0.34)
                            let tooltipHalfH = sh * 0.043
                            let overlapBar = sh * 0.01
                            let rawX = columnCenterX(index: idx, plotWidth: plotW)
                            let xClamped = min(max(rawX, tooltipW / 2), plotW - tooltipW / 2)

                            growthTooltipBubble(row: row, width: tooltipW)
                                .fixedSize(horizontal: false, vertical: true)
                                .position(x: xClamped, y: barTop - overlapBar - tooltipHalfH)
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(width: plotW, height: plotHeight, alignment: .bottomLeading)
                    .background(
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedAxisLabel = nil
                            }
                    )
                }
                .frame(height: plotHeight)

                HStack(alignment: .top, spacing: barColumnSpacing) {
                    ForEach(rows) { row in
                        Text(row.axisLabel)
                            .font(AppFont.nunitoRegular(9))
                            .foregroundStyle(Color("textColor_1").opacity(0.55))
                            .lineLimit(1)
                            .minimumScaleFactor(0.65)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    private func plotWidthPerColumn(totalWidth: CGFloat) -> CGFloat {
        guard !rows.isEmpty else { return totalWidth }
        let gaps = CGFloat(max(rows.count - 1, 0)) * barColumnSpacing
        return max((totalWidth - gaps) / CGFloat(rows.count), sh * 0.024)
    }

    private func yAxisLabels(plotHeight: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(yTicksAscending, id: \.self) { tick in
                let yCenter = plotHeight - CGFloat(tick) / CGFloat(max(yTop, 1)) * plotHeight
                Text("\(tick)")
                    .font(AppFont.nunitoRegular(10))
                    .foregroundStyle(Color("textColor_1").opacity(0.55))
                    .frame(width: sh * 0.036, alignment: .trailing)
                    .position(x: sh * 0.019, y: yCenter)
            }
        }
        .frame(height: plotHeight)
    }

    private func horizontalGrid(plotWidth: CGFloat, plotHeight: CGFloat) -> some View {
        ForEach(yTicksAscending, id: \.self) { tick in
            let y = plotHeight - CGFloat(tick) / CGFloat(max(yTop, 1)) * plotHeight
            Path { path in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: plotWidth, y: y))
            }
            .stroke(Color("textColor_1").opacity(0.12), lineWidth: 0.5)
        }
    }

    private func barHeight(daysLogged: Int, plotHeight: CGFloat) -> CGFloat {
        max(sh * 0.016, plotHeight * CGFloat(daysLogged) / CGFloat(max(yTop, 1)))
    }

    private func columnCenterX(index: Int, plotWidth: CGFloat) -> CGFloat {
        let count = rows.count
        guard count > 0 else { return plotWidth / 2 }
        let gaps = CGFloat(max(count - 1, 0)) * barColumnSpacing
        let segW = (plotWidth - gaps) / CGFloat(count)
        return CGFloat(index) * (segW + barColumnSpacing) + segW / 2
    }

    private func barCell(row: StatisticsAggregation.GrowthBarRow, plotHeight: CGFloat, columnWidth: CGFloat) -> some View {
        let barH = barHeight(daysLogged: row.daysLogged, plotHeight: plotHeight)
        let corner = sh * 0.008
        let barWidth = max(columnWidth * 0.72, sh * 0.026)

        return VStack(spacing: 0) {
            Spacer(minLength: 0)
                .allowsHitTesting(false)
            Button {
                selectedAxisLabel = row.axisLabel
            } label: {
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(chartBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .stroke(barOutline(for: row), lineWidth: sh * 0.0032)
                    )
                    .frame(width: barWidth, height: barH)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .frame(height: plotHeight, alignment: .bottom)
    }

    private func barOutline(for row: StatisticsAggregation.GrowthBarRow) -> Color {
        if selectedAxisLabel == row.axisLabel {
            return highlightYellow
        }
        return Color.white.opacity(0.95)
    }

    private func growthTooltipBubble(row: StatisticsAggregation.GrowthBarRow, width: CGFloat) -> some View {
        let corner = sh * 0.012
        return VStack(alignment: .leading, spacing: sh * 0.004) {
            Text(row.fullTitle)
                .font(AppFont.nunitoBold(14))
                .foregroundStyle(Color("textColor_1"))
                .multilineTextAlignment(.leading)
            Text("\(String(localized: "days")): \(row.daysLogged)")
                .font(AppFont.nunitoRegular(13))
                .foregroundStyle(Color("textColor_1").opacity(0.7))
        }
        .padding(.horizontal, sh * 0.016)
        .padding(.vertical, sh * 0.012)
        .frame(width: width, alignment: .leading)
        .background(tooltipFill, in: RoundedRectangle(cornerRadius: corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(tooltipStroke, lineWidth: max(1, sh * 0.002))
        )
        .shadow(color: Color.black.opacity(0.22), radius: sh * 0.012, x: 0, y: sh * 0.006)
    }
}

#Preview {
    StatisticsGrowthChartCardPreviewHost()
}

private struct StatisticsGrowthChartCardPreviewHost: View {
    @State private var sel: String?

    private var previewHabits: [Habit] {
        [
            Habit(
                title: "Morning Run",
                fishIconName: "Clownfish_1",
                streakDays: 5,
                logEntries: [
                    Habit.LogEntry(date: .now),
                    Habit.LogEntry(date: .now),
                ]
            ),
            Habit(title: "Read 20 min", fishIconName: "Angelfish_1", streakDays: 2, logEntries: [Habit.LogEntry(date: .now)]),
        ]
    }

    var body: some View {
        ZStack {
            AppBackgroundLayer()
            StatisticsGrowthChartCard(
                rows: StatisticsAggregation.growthRows(habits: previewHabits),
                selectedAxisLabel: $sel
            )
            .padding()
        }
    }
}
