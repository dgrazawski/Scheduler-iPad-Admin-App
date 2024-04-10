//
//  DisplayWeekPlanView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 24/02/2024.
//

import SwiftUI
import SwiftData




struct DisplayCycleWeekPlanView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    let hoursInDay = Array(7...20)
    var scheduleID: UUID
    
    @Query private var tiles: [CyclicTileModel]
    @Query private var allocations: [AllocationModel]
    
    @State private var showAdd: Bool = false
    @State private var showPopUp: Bool = false
    @State private var tileToPop: CyclicTileModel? = nil
    
    init(scheduleID: UUID) {
        self.scheduleID = scheduleID
        self._tiles = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        })
        self._allocations = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        })

    }
    
    var body: some View {
        VStack {
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
                                    ForEach(tiles, id: \.self){ tile in
                                        if tile.day.stringValue == day && tile.hour == hour && tile.tile != nil {
                                            AllocationTileView(subjectName: tile.tile?.subjectName ?? "", lecturerName: tile.tile?.lecturerName ?? "", groupName: tile.tile?.groupName ?? "", roomNumber: tile.tile?.roomName ?? "", groupType: tile.tile?.groupType ?? "")
                                                .onTapGesture {
                                                    if tileToPop == tile {
                                                        tileToPop = nil
                                                    } else {
                                                        tileToPop = tile    
                                                    }
                                                    
                                                  //  showPopUp = true
                                                    print(tileToPop?.ctID.uuidString ?? "")
                                                    print(showPopUp)
                                                }
                                                .popover(isPresented: Binding<Bool>(
                                                    get: { self.tileToPop == tile },
                                                    set: { _ in }
                                                )) {
                                                    if let tileToPop = tileToPop {
                                                      
                                                        AllocationPopView( tileItem: tileToPop)

                                                    }
                                                    
                                                }
                                        }
                                    }


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
            .sheet(isPresented: $showAdd) {
                AddTileView(for: scheduleID)
            }
        }
    }
}



#Preview(traits: .landscapeLeft) {
    
    ScrollView {
        DisplayCycleWeekPlanView(scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4") ?? UUID())
            .modelContainer(for: [ScheduleModel.self, GroupModel.self, MeetingModel.self, AllocationModel.self, CyclicTileModel.self])
    }
}
