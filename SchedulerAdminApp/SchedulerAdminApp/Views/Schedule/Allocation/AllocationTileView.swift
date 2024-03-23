//
//  AllocationTileView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 26/02/2024.
//

import SwiftUI

struct AllocationTileView: View {
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
        ZStack {
            Rectangle().fill(tileColor.gradient)
            VStack(alignment: .leading, spacing: 5){
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
                HStack(alignment: .center, spacing: 5) {
                    Text(groupName)
                    Spacer()
                    Text(roomNumber)
                }
                .padding(.horizontal)
                       
            }
            
        }
        .frame(maxWidth: 250, maxHeight: 150)
        .cornerRadius(15)
    }
}

#Preview {
    VStack{
        AllocationTileView(subjectName: "Informatyka 1", lecturerName: "Dr Kowalski", groupName: "Group 1", roomNumber: "50D", groupType: "Lecture")
        Spacer().frame(height: 50)
        AllocationTileView(subjectName: "Matematyka 2", lecturerName: "Dr Kozłowski", groupName: "Group 2", roomNumber: "13", groupType: "Exercise")
        Spacer().frame(height: 50)
        AllocationTileView(subjectName: "Fizyka 1", lecturerName: "Mgr Nowak", groupName: "Group 3", roomNumber: "135", groupType: "Laboratories")
        Spacer().frame(height: 50)
        AllocationTileView(subjectName: "Seminary 1", lecturerName: "Prof. Gąbka", groupName: "Group 13C", roomNumber: "11", groupType: "Seminary")
        Spacer().frame(height: 50)
        AllocationTileView(subjectName: "Angielski 3", lecturerName: "Dr Mariuszewski", groupName: "Group 4", roomNumber: "156", groupType: "Special")
    }
    
}
