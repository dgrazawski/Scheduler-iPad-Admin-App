//
//  AllocationModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import Foundation
import SwiftData

@Model
final class AllocationModel: Identifiable, Hashable, Codable {
    var id: UUID
    var scheduleID: UUID
    var lecturerID: UUID
    var groupID: UUID
    var subjectID: UUID
    var roomID: UUID
//    var lecturerName: String
//    var groupName: String
//    var groupType: String
//    var subjectName: String
//    var roomName: String
    var lecturer: LecturerModel?
    var group: GroupModel?
    var subject: SubjectModel?
    var room: RoomModel?
    @Relationship(deleteRule: .cascade) var cyclicTiles: [CyclicTileModel]
    @Relationship(deleteRule: .cascade) var nonCyclicTiles: [NonCyclicTileModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case scheduleID = "schedule_id"
        case lecturerID = "lecturer_id"
        case groupID = "group_id"
        case subjectID = "subject_id"
        case roomID = "room_id"
    }
    
    init(id: UUID = UUID(), scheduleID: UUID = UUID(), lecturerID: UUID = UUID(), groupID: UUID = UUID(), subjectID: UUID = UUID(), roomID: UUID = UUID()
//         , lecturerName: String = "Dr Kowalski", groupName: String = "G1", groupType: String = "Special", subjectName: String = "Infa 1", roomName: String = "13D"
    ) {
        self.id = id
        self.scheduleID = scheduleID
        self.lecturerID = lecturerID
        self.groupID = groupID
        self.subjectID = subjectID
        self.roomID = roomID
//        self.lecturerName = lecturerName
//        self.groupName = groupName
//        self.groupType = groupType
//        self.subjectName = subjectName
//        self.roomName = roomName
        self.cyclicTiles = []
        self.nonCyclicTiles = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        scheduleID = try container.decode(UUID.self, forKey: .scheduleID)
        lecturerID = try container.decode(UUID.self, forKey: .lecturerID)
        groupID = try container.decode(UUID.self, forKey: .groupID)
        subjectID = try container.decode(UUID.self, forKey: .subjectID)
        roomID = try container.decode(UUID.self, forKey: .roomID)
        cyclicTiles = []
        nonCyclicTiles = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(scheduleID, forKey: .scheduleID)
        try container.encode(lecturerID, forKey: .lecturerID)
        try container.encode(groupID, forKey: .groupID)
        try container.encode(subjectID, forKey: .subjectID)
        try container.encode(roomID, forKey: .roomID)
        
    }
}
