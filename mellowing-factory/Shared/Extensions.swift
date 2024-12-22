//
//  Extensions.swift
//  mellowing-factory
//
//  Created by Florian Topf on 31.07.21.
//

import Foundation
import SwiftUI
import NaturalLanguage
import Combine
import CoreImage.CIFilterBuiltins

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    
    static let ISO8601 = ISO8601DateFormatter(
        [
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]
    )
}

extension Date: RawRepresentable {
    
    public init?(rawValue: String) {
        self = Formatter.ISO8601.date(from: rawValue) ?? Date()
    }
    
    public var rawValue: String {
        Formatter.ISO8601.string(from: self)
    }
    
    public var isInFuture: Bool {
        let timeZoneOffset = TimeZone.current.secondsFromGMT() / 60
        let datePlusOffset = Calendar.current.date(byAdding: .hour, value: timeZoneOffset / 60, to: Date())!
        return self > datePlusOffset
    }
    
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let appLanguage = UserDefaults.standard.integer(forKey: "appLanguage")
        dateFormatter.locale = Locale(identifier: languageList[appLanguage].loc)
        
        return dateFormatter.string(from: self)
    }
    
    func toStringUTC(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: self)
    }
    
    func toISODate() -> String {
        return Formatter.ISO8601.string(from: self)
    }
    
    func toISODateNoColon() -> String {
        let newString = Formatter.ISO8601.string(from: self).replacingOccurrences(of: ":", with: "-", options: .literal, range: nil)
        return newString
    }
    
    var isAM: Bool {
        return self.toString(dateFormat: "a") == "AM" || self.toString(dateFormat: "a") == "오전" || self.toString(dateFormat: "a") == "午前"
    }
    
    var yesterday: Date {
        return Date().addingTimeInterval(-60 * 60 * 24).addingTimeInterval(TIME_OFFSET_D)
    }
    
    var today: Date {
        return Date().addingTimeInterval(TIME_OFFSET_D)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    var endOfWeek: Date {
        var components = DateComponents()
        components.day = 6
        let lastWeekDay = Calendar(identifier: .gregorian).date(byAdding: components, to: startOfWeek)!
        
        if !self.isSameMonth(date2: lastWeekDay) {
            return self.endOfMonth.addingTimeInterval(TIME_OFFSET_D)
        } else {
            return lastWeekDay.addingTimeInterval(TIME_OFFSET_D)
        }
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfYear: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year], from: self)
        return calendar.date(from: components)!
    }
    
    var endOfYear: Date {
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfYear)!
    }
    
    func dayOFWeek() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        if let weekday = components.weekday {
            return weekday
        }
        
        return 0
    }
    
    func isSameDay(date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    
    func isSameMonth(date2: Date) -> Bool {
        if self.endOfMonth == date2.endOfMonth {
            return true
        } else {
            return false
        }
    }
    
    func isSameYear(date2: Date) -> Bool {
        if self.endOfYear == date2.endOfYear {
            return true
        } else {
            return false
        }
    }
    
    func isSameWeek(date2: Date) -> Bool {
        if self.endOfWeek == date2.endOfWeek {
            return true
        } else {
            return false
        }
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func plusOffset() -> Date {
        return self.addingTimeInterval(TIME_OFFSET_D)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
    
    func padLeftWithZeros(totalWidth: Int) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 {
            return self
        }
        
        return "".padding(toLength: toPad, withPad: "0", startingAt: 0) + self
    }
    
    func convertToDate(format: String? = nil) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        // getting always the english version
        dateFormatter.locale = Locale(identifier: "en")
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "YYYY.MM.d"
            // converting to preferred language
            dateFormatter.locale = Locale(identifier: languageList[UserDefaults.standard.integer(forKey: "appLanguage")].loc)
            //            let formatedStringDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: 1, to: dt)!)
            return dt
        }
        
        // in case we can not convert, we just return the string
        // in case we can not convert, we just return current Date
        return Date()
    }
    
    func convertToDateString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        // getting always the english version
        dateFormatter.locale = Locale(identifier: "en")
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "YYYY.MM.d"
            // converting to preferred language
            dateFormatter.locale = Locale(identifier: languageList[UserDefaults.standard.integer(forKey: "appLanguage")].loc)
            //            let formatedStringDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: 1, to: dt)!)
            return dt.toString(dateFormat: format)
        }
        
        // in case we can not convert, we just return the string
        // in case we can not convert, we just return current Date
        return "--"
    }
    
    func checkTextSufficientComplexity(regEx: String) -> Bool {
        let texttest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return texttest.evaluate(with: self)
    }
    
    func containsUppercase() -> Bool {
        checkTextSufficientComplexity(regEx: ".*[A-Z]+.*")
    }
    
    func containsLowercase() -> Bool {
        checkTextSufficientComplexity(regEx: ".*[a-z]+.*")
    }
    
    func containsSpecialCharacters() -> Bool {
        checkTextSufficientComplexity(regEx: ".*[!&^%$#@()/]+.*")
    }
    
    func containsNumbers() -> Bool {
        checkTextSufficientComplexity(regEx: ".*[0-9]+.*")
    }
    
    func isStrongPassword() -> Bool {
        self.count >= 8 && containsUppercase() && containsLowercase() && containsSpecialCharacters() && containsNumbers()
    }
    
    func detectedLanguage() -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLanguage
    }
    
    func localized() -> String {
        let lang = languageList[UserDefaults.standard.integer(forKey: "appLanguage")].loc
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj") {
            let bundle = Bundle(path: path)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        } else if let path = Bundle.main.path(forResource: "en", ofType: "lproj") {
            let bundle = Bundle(path: path)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        } else {
            return ""
        }
    }
}

extension Data {
    var int16Array: [Int16] {
        return self.withUnsafeBytes { rawPointer -> [Int16] in
            let words = rawPointer.bindMemory(to: Int16.self)
            var array: [Int16] = []
            for index in 0..<words.count {
                array.append(words[index])
            }
            
            return array
        }
    }
}

extension Double {
//    var clean: String {
//           return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
//        }
    
    var clean: String {
        var str = self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        
        if let dotRange = str.range(of: ".") {
          str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        }
        
        return str
    }

    
    func asTimeString(style: DateComponentsFormatter.UnitsStyle,
                      units: NSCalendar.Unit = [.hour, .minute]) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = style
        let appLanguage = languageList[UserDefaults.standard.integer(forKey: "appLanguage")].loc
        formatter.calendar?.locale = Locale(identifier: appLanguage)
        // MARK: Display zeros for hours (ex.: 00:20)
        if style == .positional {
            formatter.zeroFormattingBehavior = .pad
        }

        return self.isInfinite || self.isNaN ? "" : formatter.string(from: (self * 60)) ?? ""
    }
    
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    func plusOffset() -> Double {
        let valuePlusOffset = self + Double(TIME_OFFSET_MINUTES)
        if valuePlusOffset >= 1440 {
            return valuePlusOffset - 1440
        } else {
            return valuePlusOffset
        }
    }
    
    var fahrenheit: Double {
        let celsius = Measurement(value: self, unit: UnitTemperature.celsius)
        return Defaults.temperatureUnit == 0 ? self : celsius.converted(to: .fahrenheit).value
    }
}

extension Color {
//    init(hex: Int, opacity: Double = 1.0) {
//        let red = Double((hex & 0xff0000) >> 16) / 255.0
//        let green = Double((hex & 0xff00) >> 8) / 255.0
//        let blue = Double((hex & 0xff) >> 0) / 255.0
//        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
//    }

    init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
            }

            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue:  Double(b) / 255,
                opacity: Double(a) / 255
            )
        }
    
    static let gray10 = Color("gray-10")
    static let gray50 = Color("gray-50")
    static let gray100 = Color("gray-100")
    static let gray200 = Color("gray-200")
    static let gray300 = Color("gray-300")
    static let gray400 = Color("gray-400")
    static let gray500 = Color("gray-500")
    static let gray600 = Color("gray-600")
    static let gray700 = Color("gray-700")
    static let gray800 = Color("gray-800")
    static let gray900 = Color("gray-900")
    static let gray1000 = Color("gray-1000")
    static let gray1100 = Color("gray-1100")
    
    static let green10 = Color("green-10")
    static let green50 = Color("green-50")
    static let green100 = Color("green-100")
    static let green200 = Color("green-200")
    static let green300 = Color("green-300")
    static let green400 = Color("green-400")
    static let green500 = Color("green-500")
    static let green600 = Color("green-600")
    static let green700 = Color("green-700")
    static let green800 = Color("green-800")
    static let green900 = Color("green-900")
    
    static let blue10 =  Color("blue-10")
    static let blue50 =  Color("blue-50")
    static let blue100 = Color("blue-100")
    static let blue200 = Color("blue-200")
    static let blue300 = Color("blue-300")
    static let blue400 = Color("blue-400")
    static let blue500 = Color("blue-500")
    static let blue600 = Color("blue-600")
    static let blue700 = Color("blue-700")
    static let blue800 = Color("blue-800")
    static let blue801 = Color("blue-801")
    static let blue900 = Color("blue-900")
    static let blue1000 = Color("blue-1000")
    
    static let red50 =  Color("red-50")
    static let red100 = Color("red-100")
    static let red200 = Color("red-200")
    static let red300 = Color("red-300")
    static let red400 = Color("red-400")
    static let red500 = Color("red-500")
    static let red600 = Color("red-600")
    static let red700 = Color("red-700")
    static let red800 = Color("red-800")
    static let red900 = Color("red-900")
    static let red1000 = Color("red-1000")
    
    static let yellow50 =  Color("yellow-50")
    static let yellow100 = Color("yellow-100")
    static let yellow200 = Color("yellow-200")
    static let yellow300 = Color("yellow-300")
    static let yellow400 = Color("yellow-400")
    static let yellow500 = Color("yellow-500")
    static let yellow600 = Color("yellow-600")
    static let yellow700 = Color("yellow-700")
    static let yellow800 = Color("yellow-800")
    static let yellow900 = Color("yellow-900")
    static let yellow1000 = Color("yellow-1000")
}

extension Calendar {
    func intervalOfWeek(for date: Date) -> DateInterval? {
        dateInterval(of: .weekOfYear, for: date)
    }
    
    func startOfWeek(for date: Date) -> Date? {
        intervalOfWeek(for: date)?.start
    }
    
    func daysWithSameWeekOfYear(as date: Date) -> [Date] {
        guard let startOfWeek = startOfWeek(for: date) else {
            return []
        }
        
        return (0...6).reduce(into: []) { result, daysToAdd in
            result.append(Calendar.current.date(byAdding: .day, value: daysToAdd, to: startOfWeek))
        }
        .compactMap { $0 }
    }
    
    
    func intervalOfMonth(for date: Date) -> DateInterval? {
        dateInterval(of: .month, for: date)
    }
    
    func startOfMonth(for date: Date) -> Date? {
        intervalOfMonth(for: date)?.start
    }
    
    func endOfMonth(for date: Date) -> Date? {
        intervalOfMonth(for: date)?.end
    }
    
    func daysWithSameMonthOfYear(as date: Date) -> [Date] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: date)!
        let startOfMonth = interval.start.addingTimeInterval(TIME_OFFSET_D)
        let _ = interval.end.addingTimeInterval(TIME_OFFSET_D).addingTimeInterval(-1)
        let daysCount = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!

        return (0...daysCount - 1).reduce(into: []) { result, daysToAdd in
            result.append(Calendar.current.date(byAdding: .day, value: daysToAdd, to: startOfMonth))
        }
        .compactMap { $0 }
    }
    
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime) {date, _, stop in
                if let date = date {
                    if date < interval.end {
                        dates.append(date)
                    } else {
                        stop = true
                    }
                }
            }
        return dates
    }
}

extension ArraySlice where Element == Int {
    func median() -> Int {
        guard self.count > 0 else { return 0 }
        return self.sorted(by: <)[self.count / 2]
    }
}

extension Text {
    func header() -> some View {
        self
            .foregroundColor(.gray1100)
            .font(thin18Font)
            .tracking(-1)
            .lineSpacing(6)
            .layoutPriority(1)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    @ViewBuilder func applyTextColor(_ color: Color) -> some View {
        if UITraitCollection.current.userInterfaceStyle == .light {
            self.colorInvert().colorMultiply(color)
        } else {
            self.colorMultiply(color)
        }
    }
    
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false })
//            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    @ViewBuilder
    func disabledByLanguage(_ l: Int) -> some View {
        if UserDefaults.standard.integer(forKey: "appLanguage") == l {
            EmptyView()
        } else {
            self
        }
    }
    
    @ViewBuilder
    func navigationView(back: @escaping () -> Void = {}, title: LocalizedStringKey = "", backButtonHidden: Bool = false, mode: NavigationBarItem.TitleDisplayMode = .inline, bg: LinearGradient = gradientBackground, backButtonColor: Color = Color.gray800) -> some View {
        self
            .background(bg.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(mode)
            .navigationBarItems(leading: BackButton(action: back, hidden: backButtonHidden, color: backButtonColor))
            .navigationBarTitle(Text(title).foregroundColor(.white))
//            .navigationTitle(Text(title).foregroundColor(.white))
    }
    // MARK: Gradient for Text
    public func gradientForeground(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: startPoint,
                                    endPoint: endPoint))
        .mask(self)
    }
    
    public func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}

extension Int {
    func secondsToMinutesSecondsText() -> Text {
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        
        var minutesString: String = ""
        var secondsString: String = ""
        var minutesUnits: LocalizedStringKey = ""
        var secondsUnits: LocalizedStringKey = ""
        var spacing: String = ""
        
        if minutes > 0 {
            minutesString = minutes.description
            minutesUnits = LocalizedStringKey("MINUTES")
            spacing = "  "
//            output.append("\(minutes)")
//            output.append(minutes > 1 ? " minutes" : " minute")
        }
        
        if seconds > 0 {
            secondsString = seconds.description
            secondsUnits = LocalizedStringKey("SECONDS")
//            output.append(" \(seconds)")
//            output.append(seconds > 1 ? " seconds" : " second")
        }
        
        return Text(minutesString) + Text(minutesUnits) + Text(spacing) + Text(secondsString) + Text(secondsUnits)
    }
    
    func minutesToHoursMinutesText() -> Text {
        let hours = (self % 3600) / 60
        let minutes = (self % 3600) % 60
        
        var minutesString: String = ""
        var hoursString: String = ""
        var minutesUnits: LocalizedStringKey = ""
        var hoursUnits: LocalizedStringKey = ""
        var spacing: String = ""
        
        if minutes > 0 {
            minutesString = minutes.description
            minutesUnits = LocalizedStringKey("MINUTES")
            spacing = "  "
        }
        
        if hours > 0 {
            hoursString = hours.description
            hoursUnits = LocalizedStringKey("HOURS")
        }
        
        return Text(hoursString) + Text(hoursUnits) + Text(spacing) + Text(minutesString) + Text(minutesUnits)
    }
    
    func plusOffset() -> Int {
        let valuePlusOffset = self + TIME_OFFSET_MINUTES
        if valuePlusOffset >= 1440 {
            return valuePlusOffset - 1440
        } else {
            return valuePlusOffset
        }
    }
    
    func colors() -> [Color] {
        if self > 79 {
            return [.blue100, .blue300, .blue500, .blue700, .blue100.opacity(0.1)]
        } else if self > 60 {
            return [.yellow200, .yellow400, .yellow500, .yellow700, .yellow200.opacity(0.1)]
        } else {
            return [.red100, .red300, .red500, .red700, .red100.opacity(0.1)]
        }
    }
    
    func notDetected() -> [Color] {
        return [.clear, .clear, .clear, .clear, .white]
    }
    
    func stripes() -> Color {
        if self > 79 {
            return Color("blue-stripes")
        } else if self > 60 {
            return Color("yellow-stripes")
        } else {
            return Color("red-stripes")
        }
    }
    
    func color() -> Color {
        if self > 79 {
            return .blue400.opacity(0.5)
        } else if self > 60 {
            return .yellow400.opacity(0.5)
        } else {
            return .red400.opacity(0.5)
        }
    }
    
    
    // FIXME: Languages
    func toDayWeek() -> String {
        switch self {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Error \(self)"
        }
    }
    
    func toWeekNumber() -> LocalizedStringKey {
        switch self {
        case 1: return "WEEK1"
        case 2: return "WEEK2"
        case 3: return "WEEK3"
        case 4: return "WEEK4"
        case 5: return "WEEK5"
        case 6: return "WEEK6"
        default: return "Error \(self)"
        }
    }
}

// MARK: For AppStorage / store arrays
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension UINavigationController {
    // MARK: Allows to Swipe to go back for Navigation View even when stock Back Button is hidden
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

func haptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
    let impactMed = UIImpactFeedbackGenerator(style: style)
        impactMed.impactOccurred()
}

// MARK: filtering list for unique values
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

// MARK: Custom cross-hatched background shape
// MARK: doesn't work for ios 17
//extension CGImage {
//    static func generateStripePattern(
//        colors: (UIColor, UIColor) = (.clear, .black),
//        width: CGFloat = 3,
//        ratio: CGFloat = 1) -> CGImage? {
//
//    let context = CIContext()
//    let stripes = CIFilter.stripesGenerator()
//            stripes.color0 = CIColor(color: UIColor(Color.clear))
//    stripes.color1 = CIColor(color: colors.1)
//    stripes.width = Float(width)
//    stripes.center = CGPoint(x: 1-width*ratio, y: 0)
//
//    let size = CGSize(width: width, height: 1)
//
//    guard
//        let stripesImage = stripes.outputImage,
//        let image = context.createCGImage(stripesImage, from: CGRect(origin: .zero, size: size))
//    else { return nil }
//    return image
//  }
//}
//extension Shape {
//    func stripes(color: Color) -> AnyView {
//        guard
//            let stripePattern = CGImage.generateStripePattern(colors: (UIColor(Color.clear), UIColor(color)))
//        else { return AnyView(self)}
//
//        return AnyView(Rectangle().fill(ImagePaint(
//            image: Image(decorative: stripePattern, scale: 6)))
//        .scaleEffect(5)
//        .rotationEffect(.degrees(45))
//        .clipShape(self))
//    }
//}

public struct Stripes: View {
    var color: Color

    public var body: some View {
        GeometryReader { geometry in
            let longSide = max(geometry.size.width, geometry.size.height)
            let itemWidth: CGFloat = 2
            let items = Int(2 * longSide / itemWidth)
            HStack(spacing: 1) {
                ForEach(0..<items, id: \.self) { index in
                    color
                        .frame(width: 1, height: 2 * longSide)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .rotationEffect(Angle(degrees: 45), anchor: .center)
            .offset(x: -longSide / 2, y: -longSide / 2)
            .background(Color.clear)
        }
        .clipped()
    }
}

extension Shape {
    func stripes(color: Color) -> AnyView {
        return AnyView(Stripes(color: color)
            .clipShape(self))
    }
}

extension CGImage {
    /// Load a CGImage from an image resource
    @inlinable static func named(_ name: String) -> CGImage? {
        UIImage(named: name)?.cgImage
    }
}



extension View {
    func configureNavigationBar(configure: @escaping (UINavigationController) -> Void) -> some View {
        modifier(NavigationConfigurationViewModifier(configure: configure))
    }
}

struct NavigationConfigurationViewModifier: ViewModifier {
    let configure: (UINavigationController) -> Void

    func body(content: Content) -> some View {
        content.background(NavigationConfigurator(configure: configure))
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    let configure: (UINavigationController) -> Void

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) -> NavigationConfigurationViewController {
        NavigationConfigurationViewController(configure: configure)
    }

    func updateUIViewController(
        _ uiViewController: NavigationConfigurationViewController,
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) { }
}

final class NavigationConfigurationViewController: UIViewController {
    let configure: (UINavigationController) -> Void

    init(configure: @escaping (UINavigationController) -> Void) {
        self.configure = configure
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let navigationController = navigationController {
            configure(navigationController)
        }
    }
}
