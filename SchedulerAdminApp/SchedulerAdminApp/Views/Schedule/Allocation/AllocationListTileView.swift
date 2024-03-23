//
//  AllocationListTileView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 18/03/2024.
//

import SwiftUI
import SwiftData

struct AllocationListTileView: View {
    var subjectName: String
    var lecturerName: String
    var groupName: String
    var roomNumber: String
    var groupType: String
    var tileColor: Color {
        switch(groupType) {
        case "Lecture":
            return .blue
        case "Exercise":
            return .red
        case "Laboratories":
            return .cyan
        case "Seminary":
            return .green
        case "Special":
            return .mint
        default:
            return .yellow
        }
    }
    var body: some View {

        VStack(alignment: .leading, spacing: 5){
            HStack {
                Text(subjectName)
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                Text(lecturerName)
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Text(groupType)
                Circle()
                    .fill(tileColor.gradient)
                    .frame(width: 25)
                    .padding()
            }
            
            HStack(alignment: .center, spacing: 5) {
                Text(groupName)
                Spacer()
                Text(roomNumber)
            }
            .padding(.horizontal)
                   
        }
    }
}

#Preview {
    AllocationListTileView(subjectName: "Informatyka 1", lecturerName: "Dr Kowalski", groupName: "Group 1", roomNumber: "50D", groupType: "Lecture")
        .modelContainer(for: AllocationModel.self)
}
