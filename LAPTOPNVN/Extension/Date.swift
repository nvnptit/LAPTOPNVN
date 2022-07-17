//
//  Date.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func getThisMonthStart() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
}

extension Date {
    
    var lastSaturday: Date {
        return Calendar.current.date(byAdding: .day, value: -8, to: noon)!
    }
    
    func getWeekDates() -> [Date] {
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return arrThisWeek
    }

    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon1)!
    }
    var noon1: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        if self == sunday {
            return gregorian.date(byAdding: .day, value: -6, to: sunday!)!
        } else  {
            return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
        }
    }

    func toDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Date {
    func compareTimeOnly(to: Date) -> ComparisonResult {
    let calendar = Calendar.current
    let components2 = calendar.dateComponents([.hour, .minute, .second], from: to)
    let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!, second: components2.second!, of: self)!

    let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
    if seconds == 0 {
        return .orderedSame
    } else if seconds > 0 {
        // Ascending means before
        return .orderedAscending
    } else {
        // Descending means after
        return .orderedDescending
    }
    }
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
