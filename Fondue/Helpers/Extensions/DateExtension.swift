//
//  DateExtention.swift
//  WoshApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation

extension Date {
    
    var isToday:Bool{
        return Calendar.current.isDateInToday(self)
    }
    var isYesterday:Bool{
        return Calendar.current.isDateInYesterday(self)
    }
    var isTomorrow:Bool{
        return Calendar.current.isDateInTomorrow(self)
    }
    var isWeekend:Bool{
        return Calendar.current.isDateInWeekend(self)
    }
    var year:Int{
        return (Calendar.current as NSCalendar).components(.year, from: self).year!
    }
    var month:Int{
        return (Calendar.current as NSCalendar).components(.month, from: self).month!
    }
    var weekOfYear:Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: self).weekOfYear!
    }
    var weekday:Int{
        return (Calendar.current as NSCalendar).components(.weekday, from: self).weekday!
    }
    var weekdayOrdinal:Int{
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: self).weekdayOrdinal!
    }
    var weekOfMonth:Int{
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: self).weekOfMonth!
    }
    var day:Int{
        return (Calendar.current as NSCalendar).components(.day, from: self).day!
    }
    var hour:Int{
        return (Calendar.current as NSCalendar).components(.hour, from: self).hour!
    }
    var minute:Int{
        return (Calendar.current as NSCalendar).components(.minute, from: self).minute!
    }
    var second:Int{
        return (Calendar.current as NSCalendar).components(.second, from: self).second!
    }
    var numberOfWeeks:Int{
        let weekRange = (Calendar.current as NSCalendar).range(of: .weekOfYear, in: .month, for: Date())
        return weekRange.length
    }
    var unixTimestamp:Double {
        
        return self.timeIntervalSince1970
    }
    
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func weekdayFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekday, from: date, to: self, options: []).weekday!
    }
    func weekdayOrdinalFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: date, to: self, options: []).weekdayOrdinal!
    }
    func weekOfMonthFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: date, to: self, options: []).weekOfMonth!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    ///Converts a given Date into String based on the date format and timezone provided
    func toString(dateFormat:String,timeZone:TimeZone = TimeZone.current)->String{
        
        let frmtr = DateFormatter()
        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.string(from: self)
    }
    
    func calculateAge() -> Int {
        
        let calendar : Calendar = Calendar.current
        let unitFlags : NSCalendar.Unit = [NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day]
        let dateComponentNow : DateComponents = (calendar as NSCalendar).components(unitFlags, from: Date())
        let dateComponentBirth : DateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if ( (dateComponentNow.month! < dateComponentBirth.month!) ||
            ((dateComponentNow.month! == dateComponentBirth.month!) && (dateComponentNow.day! < dateComponentBirth.day!))
            )
        {
            return dateComponentNow.year! - dateComponentBirth.year! - 1
        }
        else {
            return dateComponentNow.year! - dateComponentBirth.year!
        }
    }
    
    var timeAgoSince : String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }
}

