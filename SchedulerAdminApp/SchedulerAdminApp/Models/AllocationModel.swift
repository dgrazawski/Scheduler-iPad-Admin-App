//
//  AllocationModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import Foundation
import SwiftData

@Model
final class AllocationModel: Identifiable, Hashable {
    var id: UUID
    var scheduleID: UUID
    var lecturerID: UUID
    var groupID: UUID
    var subjectID: UUID
    var roomID: UUID
    var lecturerName: String
    var groupName: String
    var groupType: String
    var subjectName: String
    var roomName: String
    
    init(id: UUID = UUID(), scheduleID: UUID = UUID(), lecturerID: UUID = UUID(), groupID: UUID = UUID(), subjectID: UUID = UUID(), roomID: UUID = UUID(), lecturerName: String = "Dr Kowalski", groupName: String = "G1", groupType: String = "Special", subjectName: String = "Infa 1", roomName: String = "13D") {
        self.id = id
        self.scheduleID = scheduleID
        self.lecturerID = lecturerID
        self.groupID = groupID
        self.subjectID = subjectID
        self.roomID = roomID
        self.lecturerName = lecturerName
        self.groupName = groupName
        self.groupType = groupType
        self.subjectName = subjectName
        self.roomName = roomName
    }
}
