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
    @State private var checker = false
    @State private var showAlert = false
    @Query private var allocations: [AllocationModel]
    @Query private var cyclicTiles: [CyclicTileModel]
    init(for scheduleID: UUID){
        self._allocations = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        })
        self._cyclicTiles = Query(filter: #Predicate{
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
                    
                    for tile in cyclicTiles {
                        if tile.tileID == cyclicTile.tileID {
                            if tile.day == cyclicTile.day && tile.hour == cyclicTile.hour {
                                self.checker = true
                            }
                        }
                    }
                    if checker {
                        showAlert.toggle()
                    } else {
                        chosedAllocation!.cyclicTiles.append(cyclicTile)
                        context.insert(cyclicTile)
                        dismiss()
                    }
                    
                }
                .foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Add classes to schedule")
            .alert("Cannot ADD", isPresented: $showAlert) {
                Text("Classes coliding with eachother")
                Button("OK"){}
            }
        }
    }
}

#Preview {
    AddTileView(for: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4")!)
        .modelContainer(for: [ScheduleModel.self, GroupModel.self, MeetingModel.self, AllocationModel.self, CyclicTileModel.self])
}
