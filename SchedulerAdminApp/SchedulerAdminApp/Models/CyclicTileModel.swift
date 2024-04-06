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
final class CyclicTileModel: Identifiable, Hashable {
    var ctID: UUID
    var tileID: UUID
    var scheduleID: UUID
    var day: SDay
    var hour: Int
    var tile: AllocationModel?
    
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
