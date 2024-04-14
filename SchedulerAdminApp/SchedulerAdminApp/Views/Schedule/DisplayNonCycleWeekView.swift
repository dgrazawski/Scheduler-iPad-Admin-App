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
    private let hoursInDay = Array(7...20)
    private var formatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    private var formatterSecond: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    private var dateManipulator: DateManipulatorService = DateManipulatorService()
    @Query private var meetings: [MeetingModel]
    @Query private var tiles: [NonCyclicTileModel]
    @Query private var allocations: [AllocationModel]
    
    @State private var showAdd: Bool = false
    @State private var showPopUp: Bool = false
    @State private var tileToPop: NonCyclicTileModel?
    
    init(scheduleID: UUID){
        self.scheduleID = scheduleID
        self._tiles = Query(filter: #Predicate{ $0.scheduleID == scheduleID})
        self._allocations = Query(filter: #Predicate{ $0.scheduleID == scheduleID})
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
                                                ForEach(tiles, id: \.self){ tile in
                                                    if tile.tile != nil && formatter.string(from: tile.day) == formatter.string(from: day){
                                                        if Int(formatterSecond.string(from: tile.day)) == hour {
//                                                            Text(formatter.string(from: tile.day))
//                                                            Text(tile.tile?.lecturerName ?? "")
                                                            AllocationTileView(subjectName: tile.tile?.subjectName ?? "", lecturerName: tile.tile?.lecturerName ?? "", groupName: tile.tile?.groupName ?? "", roomNumber: tile.tile?.roomName ?? "", groupType: tile.tile?.groupType ?? "")
                                                                .onTapGesture {
                                                                    if tileToPop == tile {
                                                                        tileToPop = nil
                                                                    } else {
                                                                        tileToPop = tile
                                                                    }
                                                                }
                                                                .popover(isPresented: Binding<Bool>(
                                                                    get: { self.tileToPop == tile },
                                                                    set: { _ in }
                                                                )) {
                                                                    if let tileToPop = tileToPop {
                                                                      
                                                                        NoCycleAllocationPopView(tileItem: tileToPop)

                                                                    }
                                                                }
                                                            
//                                                            Button("Delete"){
//                                                                context.delete(tile)
//                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
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
