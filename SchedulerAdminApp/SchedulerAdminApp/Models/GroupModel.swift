//
//  GroupModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 13/02/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class GroupModel: Identifiable, Codable {
    var id: UUID
    var scheduleID: UUID
    var groupName: String
    var groupSize: Int
    var groupType: GroupType
    @Relationship(deleteRule: .cascade) var allocations: [AllocationModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case scheduleID = "schedule_id"
        case groupName  = "group_name"
        case groupSize = "group_size"
        case groupType = "group_type"
    }
    
    init(id: UUID = UUID(), scheduleID: UUID = UUID(), groupName: String = "", groupSize: Int = 0, groupType: GroupType = .lecture, allocations: [AllocationModel] = []) {
        self.id = id
        self.scheduleID = scheduleID
        self.groupName = groupName
        self.groupSize = groupSize
        self.groupType = groupType
        self.allocations = allocations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        scheduleID = try container.decode(UUID.self, forKey: .scheduleID)
        groupName = try container.decode(String.self, forKey: .groupName)
        groupSize = try container.decode(Int.self, forKey: .groupSize)
        groupType = try container.decode(GroupType.self, forKey: .groupType)
        allocations = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(scheduleID, forKey: .scheduleID)
        try container.encode(groupName, forKey: .groupName)
        try container.encode(groupSize, forKey: .groupSize)
        try container.encode(groupType, forKey: .groupType)
    }
    
    
    enum GroupType: Int, Hashable, Identifiable, CaseIterable, Comparable, Codable{
        static func < (lhs: GroupType, rhs: GroupType) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        var id: Int {rawValue}
        
        var stringValue: String {
            switch(self){
                
            case .lecture:
                return "Lecture"
            case .exercise:
                return "Exercise"
            case .laboratories:
               return "Laboratories"
            case .seminary:
                return "Seminary"
            case .special:
                return "Special"
            }
        }
        
        var localizedName: LocalizedStringKey{
            switch(self){
                
            case .lecture:
                return "Lecture"
            case .exercise:
                return "Exercise"
            case .laboratories:
               return "Laboratories"
            case .seminary:
                return "Seminary"
            case .special:
                return "Special"
            }
        }
        
        case lecture = 1
        case exercise
        case laboratories
        case seminary
        case special
        
        
    }
}
