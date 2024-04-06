//
//  AddTileView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 26/03/2024.
//

import SwiftUI
import SwiftData

struct AddTileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var cyclicTile: CyclicTileModel = CyclicTileModel()
    @State private var chosedAllocation: AllocationModel?
    var scheduleID: UUID
    @Query private var allocations: [AllocationModel]
    init(for scheduleID: UUID){
        self._allocations = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        })
        
        self.scheduleID = scheduleID
    }
    let hours = Array(7...20)
    @State private var day: CyclicTileModel.SDay = .monday
    @State private var hour: Int = 8
    
    var body: some View {
        NavigationStack{
            Form{
                Picker("Day", selection: $day) {
                    ForEach(CyclicTileModel.SDay.allCases) { day in
                        Text(day.stringValue).tag(day)
                    }
                }
                .pickerStyle(.segmented)
                Picker("Hour", selection: $hour) {
                    ForEach(hours, id: \.self){ hour in
                        Text("\(hour):00")
                    }
                }
                Picker("Class", selection: $chosedAllocation) {
                    ForEach(allocations) { allocation in
                        Text("\(allocation.subjectName) \(allocation.groupName) \(allocation.groupType)").tag(Optional(allocation))
                    }
                }
                Button("Add to schedule"){
                    cyclicTile.scheduleID = scheduleID
                    cyclicTile.day = day
                    cyclicTile.hour = hour
                    cyclicTile.tileID = chosedAllocation?.id ?? UUID()
                    cyclicTile.tile = chosedAllocation
                    context.insert(cyclicTile)
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
    AddTileView(for: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4")!)
        .modelContainer(for: [ScheduleModel.self, GroupModel.self, MeetingModel.self, AllocationModel.self, CyclicTileModel.self])
}
