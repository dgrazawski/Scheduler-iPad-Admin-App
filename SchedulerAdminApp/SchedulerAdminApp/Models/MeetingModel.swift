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
    var scheduleID: UUID
    var startDate: Date
    var endDate: Date
    
    init(id: UUID = UUID(), scheduleID: UUID = UUID(), startDate: Date = Date(), endDate: Date = Date()) {
        self.id = id
        self.scheduleID = scheduleID
        self.startDate = startDate
        self.endDate = endDate
    }
}
