//
//  EditRoom.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 07/02/2024.
//

import SwiftUI
import SwiftData

struct EditRoomView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var roomItem: RoomModel
   // @State private var roomItem = RoomModel()
    @State private var roomNumber = ""
    @State private var showAlert: Bool = false
    @ObservedObject private var roomSize = StripToNumberService()
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Room number", text: $roomNumber)
                TextField("Room size", text: $roomSize.value)
                Button("Change room") {
                    if roomNumber.isEmpty || roomSize.value.isEmpty {
                        showAlert = true
                    } else {
                        roomItem.roomNumber = roomNumber
                        roomItem.roomSize = Int(roomSize.value) ?? 0
                        dismiss()
                    }
                    
                }
                .foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Edit Room")
            .alert("Fill all fields", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
        }
        .onAppear{
            roomNumber = roomItem.roomNumber
            roomSize.value = String(roomItem.roomSize)
        }
    }
}

#Preview {
    EditRoomView(roomItem: RoomModel(roomNumber: "13C", roomSize: 5))
        .modelContainer(for: RoomModel.self)
}
