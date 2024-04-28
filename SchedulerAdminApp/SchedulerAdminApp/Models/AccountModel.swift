//
//  AccountModel.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 27/04/2024.
//

import Foundation
import SwiftData

@Model
final class AccountModel: Codable {
    var id:UUID
    var username: String
    var password: String
    var email: String
    var universityName: String
    var facultyName: String
    
    init(id: UUID = UUID(), username: String = "", password: String = "", email: String = "", universityName: String = "", facultyName: String = "") {
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.universityName = universityName
        self.facultyName = facultyName
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case password = "password"
        case email = "email"
        case universityName = "university_name"
        case facultyName = "faculty_name"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        email = try container.decode(String.self, forKey: .email)
        universityName = try container.decode(String.self, forKey: .universityName)
        facultyName = try container.decode(String.self, forKey: .facultyName)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(email, forKey: .email)
        try container.encode(universityName, forKey: .universityName)
        try container.encode(facultyName, forKey: .facultyName)
    }
}
