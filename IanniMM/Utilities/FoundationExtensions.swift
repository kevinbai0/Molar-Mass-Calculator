//
//  FoundationExtensions.swift
//  Tasks
//
//  Created by Kevin Bai on 2018-02-03.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import Foundation

extension Date {
    func offset(days: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(days * 3600 * 24))
    }
    func tomorrow() -> Date {
        return self.offset(days: 1)
    }
    func yesterday() -> Date {
        return self.offset(days: -1)
    }
    func nextWeek() -> Date {
        return self.offset(days: 7)
    }
    func lastWeek() -> Date {
        return self.offset(days: -7)
    }
    
    var string: String {
        get {
            let calendar = Calendar.current
            let dayOfMonth = calendar.component(.day, from: self)
            let month = calendar.component(.month, from: self)
            let year = calendar.component(.year, from: self)
            let weekday = calendar.component(.weekday, from: self)
            
            let suffix = dayOfMonth == 1 ? "st" : dayOfMonth == 2 ? "nd" : dayOfMonth == 3 ? "rd" : "th"
            
            return "\(calendar.weekdaySymbols[weekday-1]), \(calendar.monthSymbols[month-1]) \(dayOfMonth)\(suffix), \(year)"
        }
    }
}

extension Int {
    var isAsciiUppercase: Bool {
        get {
            return self >= 65 && self <= 90
        }
    }
    var isAsciiLowercase: Bool {
        get {
            return self >= 97 && self <= 122
        }
    }
    var isAsciiNumber: Bool {
        get {
            return self >= 48 && self <= 57
        }
    }
}

extension Character {
    var ascii: Int? {
        get {
            guard let first = self.unicodeScalars.first else { return nil }
            return Int(first.value)
        }
    }
    var isUppercase: Bool {
        get {
            guard let bool = ascii?.isAsciiUppercase else { return false }
            return bool
        }
    }
    var isLowercase: Bool {
        get {
            guard let bool = ascii?.isAsciiLowercase else { return false }
            return bool
        }
    }
    var isNumber: Bool {
        get {
            guard let bool = ascii?.isAsciiNumber else { return false }
            return bool
        }
    }
}

