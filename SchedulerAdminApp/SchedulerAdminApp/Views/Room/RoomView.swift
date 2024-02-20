//
//  ContentView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 13/09/2023.
//

import SwiftUI
import SwiftData

struct Room: Identifiable {
    let id = UUID()
    var number: String
    var size: Int
}

class ExampleData: ObservableObject {
    @Published var exampleData = [
        Room(number: "10D", size: 15),
        Room(number: "13", size: 10),
        Room(number: "321", size: 20)
    ]
}

struct RoomView: View {
    @Query private var roomsSD: [RoomModel]
    @State private var selectedRoomSD = Set<RoomModel>()
    @State private var sortOrderSD = [KeyPathComparator(\RoomModel.roomNumber)]
    @StateObject private var rooms = ExampleData()
    
    @State private var selectedRoom =  Set<Room.ID>()
    
    @State private var sortOrder = [KeyPathComparator(\Room.number )]
    
    @State private var isSheet = false
    
    var body: some View {
        
        NavigationStack{
            VStack{
                Table(rooms.exampleData, selection: $selectedRoom, sortOrder: $sortOrder) {
                    TableColumn("Room Number", value: \.number)
                    TableColumn("RoomSize", value: \.size){
                        value in
                        Text("\(value.size)")
                    }
                }
                .onChange(of: sortOrder) { rooms.exampleData.sort(using: $0)
                }
                HStack {
                    Text("\(rooms.exampleData.count) rooms")
                    Spacer()
                    Text("\(selectedRoom.count) rows selected")
                }
                .padding(.leading)
                .padding(.trailing)
            }.navigationTitle("Rooms")
                .sheet(isPresented: $isSheet) {
                    AddRoomView()
                        .environmentObject(rooms)
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        HStack{
                            Button {
                                isSheet.toggle()
                            } label: {
                                Label("Add Room", systemImage: "plus")
                            }
                            Button {
                                for item in selectedRoom{
                                    if let index = rooms.exampleData.firstIndex(where: {$0.id == item}){
                                        rooms.exampleData.remove(at: index)
                                    }
                                }
                                selectedRoom = Set<Room.ID>()
                            } label: {
                                Label("Delete selected room", systemImage: "trash")
                            }
                        }

                    }
                    

                }
                
        }
        

        
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView()
            .modelContainer(for: RoomModel.self)
            .previewInterfaceOrientation(.landscapeLeft)
            
    }
}
