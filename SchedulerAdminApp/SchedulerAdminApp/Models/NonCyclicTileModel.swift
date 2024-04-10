//
//  NonCyclicTileModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 09/04/2024.
//

import Foundation
import SwiftData

@Model
final class NonCyclicTileModel: Identifiable {
    var nctID: UUID
    var tileID: UUID
    var scheduleID: UUID
    var meetingID: UUID
    var day: Date
    var tile: AllocationModel?
    
    init(nctID: UUID = UUID(), tileID: UUID = UUID(), scheduleID: UUID = UUID(),meetingID:UUID = UUID(), day: Date = Date(), tile: AllocationModel? = nil) {
        self.nctID = nctID
        self.tileID = tileID
        self.scheduleID = scheduleID
        self.meetingID = meetingID
        self.day = day
        self.tile = tile
    }
}
