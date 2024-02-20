//
//  AddRoomView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 15/12/2023.
//

import SwiftUI
import SwiftData

struct AddRoomView: View {
    @EnvironmentObject private var rooms: ExampleData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var roomItem = RoomModel()
    @State private var roomNumber = ""
    @ObservedObject private var roomSize = StripToNumberService()
            
    var body: some View {
        NavigationStack {
            Form{
                TextField("Room number", text: $roomNumber)
                TextField("Room size", text: $roomSize.value)
                    .keyboardType(.decimalPad)
                Button("Add Room") {
                    roomItem.roomNumber = roomNumber
                    roomItem.roomSize = Int(roomSize.value) ?? 0
                    let room = Room(number: roomNumber, size: Int(roomSize.value) ?? 0)
                    context.insert(roomItem)
                    rooms.exampleData.append(room)
                    dismiss()
                }.foregroundColor(Color(.red))
                    .textCase(.uppercase)
            }.navigationTitle("Add Room")
            
            
                
        }
        
        
    }
}

struct AddRoomView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddRoomView()
            .environmentObject(ExampleData())
            .modelContainer(for: RoomModel.self)
    }
}
