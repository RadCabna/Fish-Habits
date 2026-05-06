import Foundation
import Observation

@Observable
final class HabitsListViewModel {
    static let completionStreakThreshold = 30

    private let storageKey = "fishHabits.userHabits.v1"
    private let archiveStorageKey = "fishHabits.archivedFish.v1"
    private let defaults = UserDefaults.standard

    var habits: [Habit] = []
    var archivedFish: [ArchivedFishRecord] = []
    var celebrationHabitID: UUID?

    init() {
        loadHabits()
        loadArchivedFish()
    }

    func dismissCelebration() {
        celebrationHabitID = nil
    }

    func archiveCompletedHabit(habitID: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == habitID }) else {
            celebrationHabitID = nil
            return
        }
        let habit = habits[index]
        let record = ArchivedFishRecord(fishIconName: habit.fishIconName, habitTitle: habit.title)
        archivedFish.insert(record, at: 0)
        habits.remove(at: index)
        celebrationHabitID = nil
        saveHabits()
        saveArchivedFish()
    }

    func addHabit(title: String, fishIconName: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        habits.insert(
            Habit(title: trimmedTitle, fishIconName: fishIconName),
            at: 0
        )
        saveHabits()
    }

    func delete(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        saveHabits()
    }

    func logDay(for habitID: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == habitID }) else { return }
        guard !hasLoggedToday(habits[index]) else { return }

        let priorStreak = habits[index].streakDays

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        let newStreak: Int
        if let lastLogged = habits[index].lastLoggedAt {
            let last = calendar.startOfDay(for: lastLogged)
            let daysBetween = calendar.dateComponents([.day], from: last, to: today).day ?? 0
            if daysBetween <= 1 {
                newStreak = habits[index].streakDays + 1
            } else {
                newStreak = 1
            }
        } else {
            newStreak = 1
        }

        habits[index].streakDays = newStreak
        habits[index].lastLoggedAt = .now
        if !habits[index].logEntries.contains(where: { Calendar.current.isDateInToday($0.date) }) {
            habits[index].logEntries.insert(Habit.LogEntry(date: .now), at: 0)
        }

        if newStreak >= Self.completionStreakThreshold && priorStreak < Self.completionStreakThreshold {
            celebrationHabitID = habitID
        }

        saveHabits()
    }

    func ensureTodayLogEntry(for habitID: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == habitID }) else { return }
        guard !habits[index].logEntries.contains(where: { Calendar.current.isDateInToday($0.date) }) else { return }
        habits[index].logEntries.insert(Habit.LogEntry(date: .now), at: 0)
        saveHabits()
    }

    func updateLogNote(habitID: UUID, entryID: UUID, note: String) {
        guard let habitIndex = habits.firstIndex(where: { $0.id == habitID }) else { return }
        guard let entryIndex = habits[habitIndex].logEntries.firstIndex(where: { $0.id == entryID }) else { return }
        habits[habitIndex].logEntries[entryIndex].note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        saveHabits()
    }

    func hasLoggedToday(_ habit: Habit) -> Bool {
        guard let lastLogged = habit.lastLoggedAt else { return false }
        return Calendar.current.isDateInToday(lastLogged)
    }

    func fishHealthOpacity(_ habit: Habit) -> Double {
        guard let lastLogged = habit.lastLoggedAt else { return 0.9 }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let last = calendar.startOfDay(for: lastLogged)
        let daysBetween = calendar.dateComponents([.day], from: last, to: today).day ?? 0
        let missedDays = max(0, daysBetween - 1)
        return max(0.38, 1 - Double(missedDays) * 0.16)
    }

    private func loadHabits() {
        guard let data = defaults.data(forKey: storageKey) else {
            habits = []
            return
        }
        do {
            habits = try JSONDecoder().decode([Habit].self, from: data)
        } catch {
            habits = []
        }
    }

    private func saveHabits() {
        do {
            let data = try JSONEncoder().encode(habits)
            defaults.set(data, forKey: storageKey)
        } catch {
            defaults.removeObject(forKey: storageKey)
        }
    }

    private func loadArchivedFish() {
        guard let data = defaults.data(forKey: archiveStorageKey) else {
            archivedFish = []
            return
        }
        do {
            archivedFish = try JSONDecoder().decode([ArchivedFishRecord].self, from: data)
        } catch {
            archivedFish = []
        }
    }

    private func saveArchivedFish() {
        do {
            let data = try JSONEncoder().encode(archivedFish)
            defaults.set(data, forKey: archiveStorageKey)
        } catch {
            defaults.removeObject(forKey: archiveStorageKey)
        }
    }
}
