//
//  RoomModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 08/01/2024.
//

import Foundation
import SwiftData

@Model
final class RoomModel: Identifiable, Codable {
    var id: UUID
    var roomNumber: String
    var roomSize: Int
    @Relationship(deleteRule: .cascade) var allocations: [AllocationModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case roomNumber = "room_number"
        case roomSize = "room_size"
    }
    
    init(id: UUID = UUID(), roomNumber: String = "", roomSize: Int = 0, allocations: [AllocationModel] = []) {
        self.id = id
        self.roomNumber = roomNumber
        self.roomSize = roomSize
        self.allocations = allocations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        roomNumber = try container.decode(String.self, forKey: .roomNumber)
        roomSize = try container.decode(Int.self, forKey: .roomSize)
        allocations = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(roomNumber, forKey: .roomNumber)
        try container.encode(roomSize, forKey: .roomSize)
    }
}
