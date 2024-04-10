//
//  DisplayNonCycleWeekView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 08/04/2024.
//

import SwiftUI
import SwiftData

struct DisplayNonCycleWeekView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    var scheduleID: UUID
    let hoursInDay = Array(7...20)
    var formatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    @Query private var meetings: [MeetingModel]
    
    @State private var showAdd: Bool = false
    @State private var showPopUp: Bool = false
    
    init(scheduleID: UUID){
        self.scheduleID = scheduleID
        
    }
    var body: some View {
        VStack{
            HStack{
                Text("Classes Schedule").font(.title)
                Button("Add classes") {
                    showAdd.toggle()
                    
                }
                .foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
                .padding()
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
            ScrollView(.horizontal) {
                HStack {
                    ForEach(meetings, id: \.self) { meeting in
//                        Text(meeting.id.uuidString)
//                            .frame(width: 1000, height: 1000)
//                            .border(Color.red)
                        Divider()
                        HStack {
                            ForEach(meeting.dateSpan, id: \.self) { day in
                                VStack{
                                    Text(formatter.string(from: day))
                                    Divider()
                                    ForEach(hoursInDay, id: \.self){ hour in
                                        VStack{
                                            Text(String(hour)+":00")
                                                .frame(height: 5)
                                                .frame(maxWidth: .infinity, alignment: .leading)

                                            Divider()
                                            HStack{
                                                ///tu kafelki
                                            }
                                            .frame(minHeight: 150)
                                        }
                                        Divider()
                                    }
                                }
                                .frame(minWidth: 250)
                                Divider()
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(20, for: .scrollContent)
            .listRowInsets(EdgeInsets())
            .sheet(isPresented: $showAdd) {
                AddNonCyclicTileView(scheduleID: scheduleID)
            }
        }
        .containerRelativeFrame(.horizontal)
    }
}

#Preview(traits: .landscapeLeft) {
    DisplayNonCycleWeekView(scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4") ?? UUID())
        .modelContainer(for: [ScheduleModel.self, GroupModel.self, MeetingModel.self, AllocationModel.self, CyclicTileModel.self, NonCyclicTileModel.self])
}
