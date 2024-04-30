//
//  SubjectModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 03/02/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class SubjectModel: Identifiable, Codable {
    var id: UUID
    var name: String
    var learningYear: LearningYear
    var hours: Int
    var labHours: Int
    @Relationship(deleteRule: .cascade) var allocations: [AllocationModel]
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case name = "subject_name"
        case learningYear = "year"
        case hours = "hours"
        case labHours = "lab_hours"
    }
    
    init(id: UUID = UUID(), name: String = "", learningYear: LearningYear = .first, hours: Int = 0, labHours: Int = 0, allocations: [AllocationModel] = []) {
        self.id = id
        self.name = name
        self.learningYear = learningYear
        self.hours = hours
        self.labHours = labHours
        self.allocations = allocations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        learningYear = try container.decode(LearningYear.self, forKey: .learningYear)
        hours = try container.decode(Int.self, forKey: .hours)
        labHours = try container.decode(Int.self, forKey: .labHours)
        allocations = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(learningYear, forKey: .learningYear)
        try container.encode(hours, forKey: .hours)
        try container.encode(labHours, forKey: .labHours)
    }
    
    enum LearningYear: Int, Hashable, CaseIterable, Codable, Comparable, Identifiable {
        var id: Int {rawValue}
        
        
        
        case first = 1
        case second
        case third
        case fourth
        case fifth
        
        var localizedName: LocalizedStringKey {
            switch(self){
            case .first:
                return "First"
            case .second:
                return "Second"
            case .third:
                return "Third"
            case .fourth:
                return "Fourth"
            case .fifth:
                return "Fifth"
            }
        }
        
        static func < (lhs: LearningYear, rhs: LearningYear) -> Bool {
                return lhs.rawValue < rhs.rawValue
            }
    }
}
