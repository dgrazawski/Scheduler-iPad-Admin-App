//
//  MeetingModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 18/02/2024.
//

import Foundation
import SwiftData

@Model
final class MeetingModel: Identifiable {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var dateSpan: [Date]
    
    init(id: UUID = UUID(), startDate: Date = Date(), endDate: Date = Date(), dateSpan: [Date] = []) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.dateSpan = dateSpan
    }
    
    func countSpan(startDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
            var date = startDate
            
            while date <= endDate {
                dates.append(date)
                guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                date = nextDay
            }
            
            return dates
    }
}
