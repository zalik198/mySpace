//
//  NotesStore.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.

import UIKit

/// Класс для хранения данных о заметке.
public final class Note: Codable {
    
    /// Название заметки.
    public var name: String
    
    /// Текст заметки
    public var text: String

    /// Время выполнения заметки.
    public var date: Date
    
    /// Даты выполнения заметки.
    public var trackDates: [Date]
    
    /// Цвет заметки для выделения в списке.
    public var color: UIColor {
        get {
            return .init(red: r, green: g, blue: b, alpha: a)
        }
        set {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            newValue.getRed(&r, green: &g, blue: &b, alpha: &a)
            self.r = r
            self.g = g
            self.b = b
            self.a = a
        }
    }
    
    /// Описание времени выполнения заметки.
    public var dateString: String {
        "Дата создания " + dateFormatter.string(from: date)
    }
    
    /// Показывает, была ли сегодня добавлена заметка.
    public var isAlreadyTakenToday: Bool {
        guard let lastTrackDate = trackDates.last else {
            return false
        }
        return calendar.isDateInToday(lastTrackDate)
    }
    
    private var r: CGFloat
    private var g: CGFloat
    private var b: CGFloat
    private var a: CGFloat
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private lazy var calendar: Calendar = .current
    
    public init(name: String, text: String, date: Date, trackDates: [Date] = [], color: UIColor) {
        self.name = name
        self.date = date
        self.trackDates = trackDates
        self.text = text
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

extension Note: Equatable {
    
    public static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.name == rhs.name &&
        lhs.date == rhs.date &&
        lhs.trackDates == rhs.trackDates &&
        lhs.text == rhs.text &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.a == rhs.a
    }
}

/// Класс для сохранения и изменения заметок пользователя.
public final class NotesStore {
    
    /// Синглтон для изменения состояния заметок из разных модулей.
    public static let shared: NotesStore = .init()
    
    /// Список заметок, добавленных пользователем. Добавленные заметки сохраняются в UserDefaults и доступны после перезагрузки приложения.
    public var notes: [Note] = [] {
        didSet {
            save()
        }
    }
    
    /// Даты с момента установки приложения с разницей в один день.
    public var dates: [Date] {
        guard let startDate = userDefaults.object(forKey: "start_date") as? Date else {
            return []
        }
        return Date.dates(from: startDate, to: .init())
    }
    
    /// Возвращает значение от 0 до 1.
    public var todayProgress: Float {
        guard notes.isEmpty == false else {
            return 0
        }
        let takenTodayNotes = notes.filter { $0.isAlreadyTakenToday }
        return Float(takenTodayNotes.count) / Float(notes.count)
    }
    
    private lazy var userDefaults: UserDefaults = .standard
    
    private lazy var decoder: JSONDecoder = .init()
    
    private lazy var encoder: JSONEncoder = .init()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private lazy var calendar: Calendar = .current
    
    // MARK: - Lifecycle
    
    /// Сохраняет все изменения в заметках в UserDefaults.
    public func save() {
        do {
            let data = try encoder.encode(notes)
            userDefaults.setValue(data, forKey: "notes")
        }
        catch {
            print("Ошибка кодирования заметок для сохранения", error)
        }
    }
    
    /// Добавляет текущую дату в trackDates для переданной заметки.
    /// - Parameter note: Заметка, в которую добавится новая дата.
    public func track(_ note: Note) {
        note.trackDates.append(.init())
        save()
    }
    
    /// Возвращает отформатированное время для даты.
    /// - Parameter index: Индекс в массиве dates.
    public func trackDateString(forIndex index: Int) -> String? {
        guard index < dates.count else {
            return nil
        }
        return dateFormatter.string(from: dates[index])
    }
    
    /// Показывает, была ли затрекана заметка в переданную дату.
    /// - Parameters:
    ///   - note: Заметка, у которой проверяются затреканные даты.
    ///   - date: Дата, для которой проверяется, была ли затрекана заметка.
    /// - Returns: Возвращает true, если заметка была затрекана в переданную дату.
    public func note(_ note: Note, isTrackedIn date: Date) -> Bool {
        note.trackDates.contains { trackDate in
            calendar.isDate(date, equalTo: trackDate, toGranularity: .day)
        }
    }
    
    // MARK: - Private
    
    private init() {
        if userDefaults.value(forKey: "start_date") == nil {
            let startDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            userDefaults.setValue(startDate, forKey: "start_date")
        }
        guard let data = userDefaults.data(forKey: "notes") else {
            return
        }
        do {
            notes = try decoder.decode([Note].self, from: data)
        }
        catch {
            print("Ошибка декодирования сохранённых заметок", error)
        }
    }
}

private extension Date {
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
                break
            }
            date = newDate
        }
        return dates
    }
}
