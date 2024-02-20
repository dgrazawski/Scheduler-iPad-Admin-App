//
//  AddRoomSDView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 04/02/2024.
//

import SwiftUI
import SwiftData

struct AddRoomSDView: View {
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
                    context.insert(roomItem)
                    
                    dismiss()
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
                
            }.navigationTitle("Add Room")
            
            
                
        }
    }
}

#Preview {
    AddRoomSDView()
        .modelContainer(for: RoomModel.self)
}
