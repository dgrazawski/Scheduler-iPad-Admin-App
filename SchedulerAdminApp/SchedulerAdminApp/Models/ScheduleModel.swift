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
final class ScheduleModel: Codable {
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        scheduleName = try container.decode(String.self, forKey: .scheduleName)
        year = try container.decode(Year.self, forKey: .year)
        isCyclic = try container.decode(Bool.self, forKey: .isCyclic)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(scheduleName, forKey: .scheduleName)
        try container.encode(year, forKey: .year)
        try container.encode(isCyclic, forKey: .isCyclic)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case scheduleName = "schedule_name"
        case year = "year"
        case isCyclic = "is_cyclic"
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
