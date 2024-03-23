//
//  DisplayWeekPlanView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 24/02/2024.
//

import SwiftUI




struct DisplayWeekPlanView: View {
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri"]
       let hoursInDay = Array(7...20) // 24-hour format
       

    var body: some View {
        VStack {
            HStack{
                Text("Classes Schedule").font(.title)
                Spacer()
                Circle()
                    .fill(.blue.gradient)
                    .frame(width: 25)
                Text("Lectures")
                Circle()
                    .fill(.red.gradient)
                    .frame(width: 25)
                Text("Exercises")
                Circle()
                    .fill(.cyan.gradient)
                    .frame(width: 25)
                Text("Laboratories")
                Circle()
                    .fill(.green.gradient)
                    .frame(width: 25)
                Text("Seminaries")
                Circle()
                    .fill(.mint.gradient)
                    .frame(width: 25)
                Text("Special")
            }
            .padding()
            HStack {
                Divider()
                ForEach(daysOfWeek, id: \.self){day in
                    VStack{
                        Text(day)
                        Divider()
                        ForEach(hoursInDay, id: \.self){hour in
                            VStack {
                                Text(String(hour)+":00")
                                    .frame(height: 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Divider()
                                HStack{
                                    if day == "Mon" && hour == 13 {
                                        AllocationTileView(subjectName: "Matematyka 1", lecturerName: "Dr Kowalski", groupName: "Group 1", roomNumber: "15D", groupType: "Special")
                                    }
                                    if day == "Wed" && hour == 7 {
                                        AllocationTileView(subjectName: "Matematyka 1", lecturerName: "Dr Kowalski", groupName: "Group 1", roomNumber: "15D", groupType: "Exercise")
                                    }
                                    AllocationTileView(subjectName: "Matematyka 1", lecturerName: "Dr Kowalski", groupName: "Group 1", roomNumber: "15D", groupType: "Special")
                                    AllocationTileView(subjectName: "Matematyka 1", lecturerName: "Dr Kowalski", groupName: "Group 1", roomNumber: "15D", groupType: "Lecture")

                                }
                                .frame(minHeight: 150)
                            }
                            Divider()
                        }
                    }
                    .frame(minWidth: 100)
                    Divider()
                }
            }
        }
    }
}



#Preview(traits: .landscapeLeft) {
    
    ScrollView {
        DisplayWeekPlanView()
    }
}
