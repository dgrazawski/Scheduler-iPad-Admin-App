//
//  MeetingModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 18/02/2024.
//

import Foundation
import SwiftData

@Model
final class MeetingModel: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var endDate: Date
    var dateSpan: [Date]
    @Relationship(deleteRule: .cascade) var tiles: [NonCyclicTileModel]
    
    init(id: UUID = UUID(), startDate: Date = Date(), endDate: Date = Date(), dateSpan: [Date] = [], tiles: [NonCyclicTileModel] = []) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.dateSpan = dateSpan
        self.tiles = tiles
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        dateSpan = []
        tiles = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        
    }
    
    func countSpan(startDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
            var date = startDate
            
            while date <= endDate {
                dates.append(date)
                guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                date = nextDay
            }
            
            return dates
    }
}
