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
final class LecturerModel: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
    var lecturerName: String
    var lecturerLastName: String
    var degree: Degree
    @Relationship(deleteRule: .cascade) var allocations: [AllocationModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lecturerName = "lecturer_name"
        case lecturerLastName = "lecturer_lastname"
        case degree = "degree"
    }
    
    init(id: UUID = UUID(), lecturerName: String = "", lecturerLastName: String = "", degree: Degree = .doctor, allocations: [AllocationModel] = []) {
        self.id = id
        self.lecturerName = lecturerName
        self.lecturerLastName = lecturerLastName
        self.degree = degree
        self.allocations = allocations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        lecturerName = try container.decode(String.self, forKey: .lecturerName)
        lecturerLastName = try container.decode(String.self, forKey: .lecturerLastName)
        degree = try container.decode(Degree.self, forKey: .degree)
        allocations = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(lecturerName, forKey: .lecturerName)
        try container.encode(lecturerLastName, forKey: .lecturerLastName)
        try container.encode(degree, forKey: .degree)
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
