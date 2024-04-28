//
//  LecturerModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 04/02/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class LecturerModel: Identifiable {
    var id: UUID
    var lecturerName: String
    var lecturerLastName: String
    var degree: Degree
    @Relationship(deleteRule: .cascade) var allocations: [AllocationModel]
    
    init(id: UUID = UUID(), lecturerName: String = "", lecturerLastName: String = "", degree: Degree = .doctor) {
        self.id = id
        self.lecturerName = lecturerName
        self.lecturerLastName = lecturerLastName
        self.degree = degree
        self.allocations = []
    }
    
    enum Degree: Int, Hashable, Identifiable, CaseIterable, Comparable, Codable {
        var id: Int {rawValue}
        
        static func < (lhs: Degree, rhs: Degree) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        case master = 1
        case doctor
        case habilitated
        case professor
        
        var stringValue: String {
            switch(self){
            
            case .master:
                return "Master"
            case .doctor:
                return "Doctor"
            case .habilitated:
                return "Habilitated Doctor"
            case .professor:
                return "Professor"
            }
        }
        var localizedName:LocalizedStringKey{
            switch(self){
            
            case .master:
                return "Master"
            case .doctor:
                return "Doctor"
            case .habilitated:
                return "Habilitated Doctor"
            case .professor:
                return "Professor"
            }
        }
    }
}
