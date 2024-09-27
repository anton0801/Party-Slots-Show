import Foundation

class DailyBonusManager: ObservableObject {
    @Published var currentDay: Int
    @Published var lastClaimedDay: Int
    
    let maxDays = 7
    private let initialBonus = 2000
    private let userDefaults = UserDefaults.standard
    
    private let lastClaimedDayKey = "lastClaimedDayKey"
    private let currentDayKey = "currentDayKey"
    
    init() {
        // Загрузка данных из UserDefaults
        self.lastClaimedDay = userDefaults.integer(forKey: lastClaimedDayKey)
        self.currentDay = userDefaults.integer(forKey: currentDayKey)
    }
    
    // Метод для проверки, доступен ли бонус для конкретного дня
    func isBonusAvailable(for day: Int) -> Bool {
        return day == lastClaimedDay + 1
    }
    
    // Метод для получения бонуса на указанный день
    func getBonusAmount(for day: Int) -> Int {
        return initialBonus + ((day - 1) * 2000)
    }
    
    // Метод для получения бонуса на конкретный день
    func claimBonus(for day: Int) -> Int? {
        if isBonusAvailable(for: day) {
            let bonusAmount = getBonusAmount(for: day)
            
            // Обновляем данные в UserDefaults
            lastClaimedDay = day
            userDefaults.set(lastClaimedDay, forKey: lastClaimedDayKey)
            
            return bonusAmount
        }
        return nil // Бонус недоступен для указанного дня
    }
    
    // Сброс прогресса бонусов
    func resetBonusProgress() {
        userDefaults.removeObject(forKey: lastClaimedDayKey)
        userDefaults.removeObject(forKey: currentDayKey)
        lastClaimedDay = 0
        currentDay = 0
    }
}
