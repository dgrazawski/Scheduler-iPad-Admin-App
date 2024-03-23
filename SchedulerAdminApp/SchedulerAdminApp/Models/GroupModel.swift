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
final class GroupModel: Identifiable {
    var id: UUID
    var scheduleID: UUID
    var groupName: String
    var groupSize: Int
    var groupType: GroupType
    
    init(id: UUID = UUID(), scheduleID: UUID = UUID(), groupName: String = "", groupSize: Int = 0, groupType: GroupType = .lecture) {
        self.id = id
        self.scheduleID = scheduleID
        self.groupName = groupName
        self.groupSize = groupSize
        self.groupType = groupType
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
