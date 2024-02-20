//
//  AllocationModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import Foundation
import SwiftData

@Model
final class AllocationModel: Identifiable {
    var id: UUID
    var scheduleID: UUID
    var lecturerID: UUID
    var groupID: UUID
    var subjectID: UUID
    
    init(id: UUID = UUID(), scheduleID: UUID = UUID(), lecturerID: UUID = UUID(), groupID: UUID = UUID(), subjectID: UUID = UUID()) {
        self.id = id
        self.scheduleID = scheduleID
        self.lecturerID = lecturerID
        self.groupID = groupID
        self.subjectID = subjectID
    }
}
