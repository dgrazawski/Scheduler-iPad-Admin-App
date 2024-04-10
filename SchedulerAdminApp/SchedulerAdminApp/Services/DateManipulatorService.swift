//
//  DateManipulatorService.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 24/03/2024.
//

import Foundation

class DateManipulatorService {
    
    private var calendar: Calendar {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? calendar.timeZone // Example: Use GMT
            return calendar
        }
    
    func changeStartDate(startDate: Date) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: startDate)
        components.hour = 0
        components.minute = 0
        return calendar.date(from: components) ?? startDate
    }
    
    func changeEndDate(endDate: Date) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: endDate)
        components.hour = 23
        components.minute = 59
        return calendar.date(from: components) ?? endDate
    }
    
    func setHourInDate(dateToSet: Date, hour: Int) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: dateToSet)
        components.hour = hour
        components.minute = 0
        return calendar.date(from: components) ?? dateToSet
    }
}
