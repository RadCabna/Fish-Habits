import Foundation

enum StatisticsPeriod: Hashable {
    case month
    case year
}

enum StatisticsAggregation {
    static func chartCeiling(maxValue: Int, steps: Int) -> Int {
        let step = max(1, steps)
        let raw = max(maxValue, step)
        return ((raw + step - 1) / step) * step
    }

    static func habitsCreatedCount(active habits: [Habit], archived: [ArchivedFishRecord]) -> Int {
        habits.count + archived.count
    }

    static func fishGrownCount(archived: [ArchivedFishRecord]) -> Int {
        archived.count
    }

    static func longestStreakDays(among habits: [Habit]) -> Int {
        habits.map { max(longestConsecutiveLoggedDays(entries: $0.logEntries), $0.streakDays) }.max() ?? 0
    }

    static func longestConsecutiveLoggedDays(entries: [Habit.LogEntry]) -> Int {
        let calendar = Calendar.current
        let uniqueDays = Set(entries.map { calendar.startOfDay(for: $0.date) }).sorted()
        guard !uniqueDays.isEmpty else { return 0 }
        var best = 1
        var run = 1
        var previous = uniqueDays[0]
        for day in uniqueDays.dropFirst() {
            let gap = calendar.dateComponents([.day], from: previous, to: day).day ?? 0
            if gap == 1 {
                run += 1
                best = max(best, run)
            } else {
                run = 1
            }
            previous = day
        }
        return best
    }

    static func activityByDayLast30(habits: [Habit], now: Date = .now, calendar: Calendar = .current) -> [(index: Int, count: Int)] {
        let today = calendar.startOfDay(for: now)
        var rows: [(index: Int, count: Int)] = []
        for i in 0 ..< 30 {
            guard let day = calendar.date(byAdding: .day, value: -(29 - i), to: today) else { continue }
            let count = habits.flatMap(\.logEntries).filter { calendar.isDate($0.date, inSameDayAs: day) }.count
            rows.append((index: i + 1, count: count))
        }
        return rows
    }

    static func activityByMonthInYear(habits: [Habit], now: Date = .now, calendar: Calendar = .current) -> [(monthKey: String, count: Int)] {
        let year = calendar.component(.year, from: now)
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMM"
        var result: [(monthKey: String, count: Int)] = []
        for month in 1 ... 12 {
            var comps = DateComponents()
            comps.year = year
            comps.month = month
            comps.day = 1
            guard let start = calendar.date(from: comps) else { continue }
            let label = formatter.string(from: start)
            let count = habits.flatMap(\.logEntries).filter { entry in
                calendar.component(.year, from: entry.date) == year && calendar.component(.month, from: entry.date) == month
            }.count
            result.append((monthKey: label, count: count))
        }
        return result
    }

    struct GrowthBarRow: Identifiable, Hashable {
        let id: UUID
        let fullTitle: String
        let axisLabel: String
        let daysLogged: Int
    }

    static func growthRows(habits: [Habit], axisCharLimit: Int = 11) -> [GrowthBarRow] {
        habits
            .map { habit in
                GrowthBarRow(
                    id: habit.id,
                    fullTitle: habit.title,
                    axisLabel: truncatedAxisTitle(habit.title, limit: axisCharLimit),
                    daysLogged: habit.logEntries.count
                )
            }
            .sorted { $0.daysLogged > $1.daysLogged }
    }

    static func truncatedAxisTitle(_ title: String, limit: Int) -> String {
        guard title.count > limit else { return title }
        let prefixLen = max(1, limit - 3)
        return String(title.prefix(prefixLen)) + "..."
    }
}
