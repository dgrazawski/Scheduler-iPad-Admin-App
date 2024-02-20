//
//  ScheduleModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 08/01/2024.
//

import Foundation
import SwiftData
import SwiftUI



@Model
final class ScheduleModel {
    var id: UUID
    var scheduleName: String
    var year: Year
    var isCyclic: Bool
    
    init(id: UUID = UUID(), scheduleName: String = "", year: Year = .first, isCyclic: Bool = false) {
        self.id = id
        self.scheduleName = scheduleName
        self.year = year
        self.isCyclic = isCyclic
    }
    
    enum Year: Int, Hashable, CaseIterable, Codable, Comparable, Identifiable {
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
        
        static func < (lhs: Year, rhs: Year) -> Bool {
                return lhs.rawValue < rhs.rawValue
            }
    }
}
