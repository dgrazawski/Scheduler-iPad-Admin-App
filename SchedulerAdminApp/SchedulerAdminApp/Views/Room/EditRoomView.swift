//
//  EditRoom.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 07/02/2024.
//

import SwiftUI
import SwiftData

struct EditRoomView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
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
                        
                        let data = try? JSONEncoder().encode(roomItem)
                        var url = URLRequestBuilder().createURL(route: .room, endpoint: .editDelete, parameter: roomItem.id.uuidString)!
                        print(url)
                        var request = URLRequestBuilder().createRequest(method: .put, url: url, body: data)
                        request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                        networkService.sendDataGetResponseWithCodeOnly(request: request!)
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
