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
final class SubjectModel: Identifiable {
    var id: UUID
    var name: String
    var learningYear: LearningYear
    var hours: Int
    var labHours: Int
    
    init(id: UUID = UUID(), name: String = "", learningYear: LearningYear = .first, hours: Int = 0, labHours: Int = 0) {
        self.id = id
        self.name = name
        self.learningYear = learningYear
        self.hours = hours
        self.labHours = labHours
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
