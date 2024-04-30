//
//  NonCyclicTileModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 09/04/2024.
//

import Foundation
import SwiftData

@Model
final class NonCyclicTileModel: Identifiable, Codable {
    var nctID: UUID
    var tileID: UUID
    var scheduleID: UUID
    var meetingID: UUID
    var day: Date
    var tile: AllocationModel?
    var meeting: MeetingModel?
    
    enum CodingKeys: String, CodingKey {
        case nctID = "id"
        case tileID = "allocation_id"
        case scheduleID = "schedule_id"
        case meetingID = "meeting_id"
        case day = "day"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nctID = try container.decode(UUID.self, forKey: .nctID)
        tileID = try container.decode(UUID.self, forKey: .tileID)
        scheduleID = try container.decode(UUID.self, forKey: .scheduleID)
        meetingID = try container.decode(UUID.self, forKey: .meetingID)
        day = try container.decode(Date.self, forKey: .day)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nctID, forKey: .nctID)
        try container.encode(tileID, forKey: .tileID)
        try container.encode(scheduleID, forKey: .scheduleID)
        try container.encode(meetingID, forKey: .meetingID)
        try container.encode(day, forKey: .day)
    }
    
    init(nctID: UUID = UUID(), tileID: UUID = UUID(), scheduleID: UUID = UUID(),meetingID:UUID = UUID(), day: Date = Date(), tile: AllocationModel? = nil, meeting: MeetingModel? = nil) {
        self.nctID = nctID
        self.tileID = tileID
        self.scheduleID = scheduleID
        self.meetingID = meetingID
        self.day = day
        self.tile = tile
        self.meeting = meeting
    }
}
