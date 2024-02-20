//
//  GroupTileView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 15/02/2024.
//

import SwiftUI

struct GroupTileView: View {
    var groupName: String
    var groupSize: Int
    var groupType: LocalizedStringKey
    var image: String {
        switch(groupType){
        case "Lecture":
            return "book.fill"
        case "Exercise":
            return "pencil.and.ruler.fill"
        case "Laboratories":
            return "compass.drawing"
        case "Special":
            return "star.fill"
        default:
            return "trash.fill"
        }
    }
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(groupName)
                    .font(.title)
                    .padding(.bottom)
                Text("People in group: \(groupSize)")
                
            }
            Spacer()
            VStack {
                Text(groupType)
                    .font(.title2)
                    .padding(.bottom)
                Label("", systemImage: image)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(.trailing)
        }
        .padding(.horizontal)
    }
}

#Preview {
    GroupTileView(groupName: "Group 1", groupSize: 5, groupType: "Lecture")
}
