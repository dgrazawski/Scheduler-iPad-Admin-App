//
//  CyclicTileModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 26/03/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class CyclicTileModel: Identifiable, Hashable, Codable {
    var ctID: UUID
    var tileID: UUID
    var scheduleID: UUID
    var day: SDay
    var hour: Int
    var tile: AllocationModel?
    
    enum CodingKeys: String, CodingKey {
        case ctID = "id"
        case tileID = "allocation_id"
        case scheduleID = "schedule_id"
        case day = "day"
        case hour = "hour"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ctID = try container.decode(UUID.self, forKey: .ctID)
        tileID = try container.decode(UUID.self, forKey: .tileID)
        scheduleID = try container.decode(UUID.self, forKey: .scheduleID)
        day = try container.decode(SDay.self, forKey: .day)
        hour = try container.decode(Int.self, forKey: .hour)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ctID, forKey: .ctID)
        try container.encode(tileID, forKey: .tileID)
        try container.encode(scheduleID, forKey: .scheduleID)
        try container.encode(day, forKey: .day)
        try container.encode(hour, forKey: .hour)
    }
    
    enum SDay: Int, Hashable, CaseIterable, Codable, Comparable, Identifiable {
        static func < (lhs: CyclicTileModel.SDay, rhs: CyclicTileModel.SDay) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        var id: Int {rawValue}
        
        case monday = 1
        case tuesday
        case wednesday
        case thursday
        case friday
        
        var localizedName: LocalizedStringKey {
            switch (self) {
            case .monday:
                return "Mon"
            case .tuesday:
                return "Tue"
            case .wednesday:
                return "Wed"
            case .thursday:
                return "Thu"
            case .friday:
                return "Fri"
            }
        }
        
        var stringValue: String {
            switch (self) {
            case .monday:
                return "Mon"
            case .tuesday:
                return "Tue"
            case .wednesday:
                return "Wed"
            case .thursday:
                return "Thu"
            case .friday:
                return "Fri"
            }
        }
        
    }
    
    init(ctID: UUID = UUID(), tileID: UUID = UUID(), scheduleID: UUID = UUID(), day: SDay = .monday, hour: Int = 13) {
        self.ctID = ctID
        self.tileID = tileID
        self.scheduleID = scheduleID
        self.day = day
        self.hour = hour
    }

}
