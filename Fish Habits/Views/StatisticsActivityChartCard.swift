import Charts
import SwiftUI

struct StatisticsActivityChartCard: View {
    let period: StatisticsPeriod
    let monthPoints: [(index: Int, count: Int)]
    let yearPoints: [(monthKey: String, count: Int)]

    private var sh: CGFloat { ScreenMetrics.screenHeight }
    private var chartBlue: Color { Color("appColor_1") }
    private var axisLabelColor: Color { Color("textColor_1").opacity(0.55) }

    private var cardTitle: String {
        period == .month
            ? String(localized: "Activity by Month")
            : String(localized: "Activity by Year")
    }

    private var maxCount: Int {
        switch period {
        case .month:
            max(monthPoints.map(\.count).max() ?? 0, 1)
        case .year:
            max(yearPoints.map(\.count).max() ?? 0, 1)
        }
    }

    private var yTop: Int {
        StatisticsAggregation.chartCeiling(maxValue: maxCount, steps: period == .month ? 4 : 15)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: sh * 0.012) {
            Text(cardTitle)
                .font(AppFont.nunitoBold(17))
                .foregroundStyle(Color("textColor_1"))

            Group {
                switch period {
                case .month:
                    monthChart
                case .year:
                    yearChart
                }
            }
            .frame(height: sh * 0.24)
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

    private var monthChart: some View {
        Chart {
            ForEach(monthPoints, id: \.index) { point in
                LineMark(
                    x: .value("Day", point.index),
                    y: .value("Logs", point.count)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(chartBlue)
                .lineStyle(StrokeStyle(lineWidth: sh * 0.003))

                PointMark(
                    x: .value("Day", point.index),
                    y: .value("Logs", point.count)
                )
                .foregroundStyle(.white)
                .symbol(.circle)
                .symbolSize(sh * 0.055)
            }
        }
        .chartYScale(domain: 0 ... yTop)
        .chartXScale(domain: 1 ... 30)
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(axisLabelColor)
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(axisLabelColor)
            }
        }
    }

    private var yearChart: some View {
        Chart {
            ForEach(yearPoints, id: \.monthKey) { row in
                LineMark(
                    x: .value("Month", row.monthKey),
                    y: .value("Logs", row.count)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(chartBlue)
                .lineStyle(StrokeStyle(lineWidth: sh * 0.003))

                PointMark(
                    x: .value("Month", row.monthKey),
                    y: .value("Logs", row.count)
                )
                .foregroundStyle(.white)
                .symbol(.circle)
                .symbolSize(sh * 0.055)
            }
        }
        .chartYScale(domain: 0 ... yTop)
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(axisLabelColor)
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(axisLabelColor)
            }
        }
    }
}

#Preview {
    ZStack {
        AppBackgroundLayer()
        StatisticsActivityChartCard(
            period: .month,
            monthPoints: StatisticsAggregation.activityByDayLast30(habits: []),
            yearPoints: StatisticsAggregation.activityByMonthInYear(habits: [])
        )
        .padding()
    }
}
