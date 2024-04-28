//
//  RoomModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 08/01/2024.
//

import Foundation
import SwiftData

@Model
final class RoomModel: Identifiable {
    var id: UUID
    var roomNumber: String
    var roomSize: Int
    @Relationship(deleteRule: .cascade) var allocations: [AllocationModel]
    
    init(id: UUID = UUID(), roomNumber: String = "", roomSize: Int = 0) {
        self.id = id
        self.roomNumber = roomNumber
        self.roomSize = roomSize
        self.allocations = []
    }
}
