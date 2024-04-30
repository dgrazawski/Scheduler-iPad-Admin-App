//
//  AddNonCyclicTileView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 09/04/2024.
//

import SwiftUI
import SwiftData

struct AddNonCyclicTileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    var scheduleID: UUID
    private let hours = Array(7...20)
    private var displayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    private let dateManipulator: DateManipulatorService = DateManipulatorService()
    @State private var hour: Int = 8
    @State private var day: Date = Date()
    @State private var nonCyclicTile: NonCyclicTileModel = NonCyclicTileModel()
    @State private var chosedAllocation: AllocationModel?
    @State private var meeting: MeetingModel?
    
    @Query private var allocations: [AllocationModel]
    @Query(sort: \MeetingModel.startDate) private var meetings: [MeetingModel]
    init(scheduleID: UUID){
        self.scheduleID = scheduleID
        self._allocations = Query(filter: #Predicate{ $0.scheduleID == scheduleID })
    }
    var body: some View {
        NavigationStack{
            Form{
                Picker("Meeting", selection: $meeting){
                    Text("None").tag(nil as MeetingModel?)
                    ForEach(meetings, id: \.self){ meeting in
                        Text(displayFormatter.string(from: meeting.startDate) + "-" + displayFormatter.string(from: meeting.endDate)).tag(Optional(meeting))
                    }
                }
                
                Picker("Day", selection: $day){
                    Text("None").tag(nil as Date?)
                    ForEach(meeting?.dateSpan ?? [], id: \.self){ day in
                        Text(displayFormatter.string(from: day)).tag(Optional(day))
                        
                    }
                }
                Picker("Hour", selection: $hour) {
                    ForEach(hours, id: \.self){ hour in
                        Text("\(hour):00").tag(hour)
                    }
                }
                Picker("Class", selection: $chosedAllocation) {
                    Text("None").tag(nil as AllocationModel?)
                    ForEach(allocations) { allocation in
                        Text("\(allocation.subjectName) \(allocation.groupName) \(allocation.groupType)").tag(Optional(allocation))
                    }
                }
                Button("Add to schedule"){
                    nonCyclicTile.scheduleID = scheduleID
                    nonCyclicTile.meetingID = meeting?.id ?? UUID()
                    nonCyclicTile.tile = chosedAllocation
                    nonCyclicTile.tileID = chosedAllocation?.id ?? UUID()
                    nonCyclicTile.day = dateManipulator.setHourInDate(dateToSet: day, hour: hour)
                    print(displayFormatter.string(from: nonCyclicTile.day))
                    chosedAllocation?.nonCyclicTiles.append(nonCyclicTile)
                    context.insert(nonCyclicTile)
                    dismiss()
                }
                .foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add classes to schedule")
        }
    }
}

#Preview {
    AddNonCyclicTileView(scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4") ?? UUID())
        .modelContainer(for: [ScheduleModel.self, GroupModel.self, MeetingModel.self, AllocationModel.self, NonCyclicTileModel.self])
}
