//
//  RoomSDView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 04/02/2024.
//

import SwiftUI
import SwiftData

struct RoomSDView: View {
    @Environment(\.modelContext) var context
    @Query private var roomsSD: [RoomModel]
    @State private var selectedRoomSD = Set<RoomModel.ID>()
    @State private var sortOrderSD = [KeyPathComparator(\RoomModel.roomNumber)]
    @State private var oneRoom: RoomModel?
    
    var sortedRooms: [RoomModel] {
        roomsSD.sorted(using: sortOrderSD)
    }
    
    @State private var isSheet = false
    @State private var isEdit = false
    var body: some View {
        NavigationStack{
            VStack{
                Table(sortedRooms, selection: $selectedRoomSD ,sortOrder: $sortOrderSD) {
                    TableColumn("Room Number", value: \.roomNumber)
                    TableColumn("RoomSize", value: \.roomSize){
                        value in
                        Text("\(value.roomSize)")
                    }
                }
                .overlay{
                    if sortedRooms.isEmpty {
                        ContentUnavailableView("No rooms added", systemImage: "key.fill")
                    }
                }
                .onChange(of: sortOrderSD) {
                    sortedRooms.sorted(using: $0)
                }
                HStack {
                    Text("\(sortedRooms.count) rooms")
                    Spacer()
                    Text("\(selectedRoomSD.count) rooms selected")
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .navigationTitle("Rooms")
                .sheet(isPresented: $isSheet) {
                    AddRoomSDView()
                        
                }
                .sheet(isPresented: $isEdit, content: {
                    EditRoomView(roomItem: oneRoom!)
                })
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        HStack{
                            Button {
                                isSheet.toggle()
                            } label: {
                                Label("Add Room", systemImage: "plus")
                            }
                            Button {
                                for item in selectedRoomSD{
                                    if let index = sortedRooms.firstIndex(where: {$0.id == item}){
                                        oneRoom = sortedRooms[index]
                                        isEdit.toggle()
                                        
                                    }
                                }
                                selectedRoomSD = Set<RoomModel.ID>()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .disabled(selectedRoomSD.count != 1)

                            Button {
                                for item in selectedRoomSD{
                                    if let index = sortedRooms.firstIndex(where: {$0.id == item}){
                                        oneRoom = sortedRooms[index]
                                       
                                        context.delete(oneRoom!)
                                    }
                                }
                                selectedRoomSD = Set<RoomModel.ID>()
                            } label: {
                                Label("Delete selected room", systemImage: "trash")
                            }
                        }

                    }
                    

                }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    RoomSDView()
        .modelContainer(for: RoomModel.self)
}
