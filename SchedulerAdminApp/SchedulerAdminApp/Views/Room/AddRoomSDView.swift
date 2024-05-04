//
//  AddRoomSDView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 04/02/2024.
//

import SwiftUI
import SwiftData

struct AddRoomSDView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var roomItem = RoomModel()
    @State private var roomNumber = ""
    @ObservedObject private var roomSize = StripToNumberService()
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack {
            Form{
                TextField("Room number", text: $roomNumber)
                TextField("Room size", text: $roomSize.value)
                    .keyboardType(.numberPad)
                
                Button("Add Room") {
                    if roomNumber.isEmpty || roomSize.value.isEmpty {
                        showAlert = true
                    } else {
                        roomItem.roomNumber = roomNumber
                        roomItem.roomSize = Int(roomSize.value) ?? 0
                        
                        let data = try? JSONEncoder().encode(roomItem)
                        var url = URLRequestBuilder().createURL(route: .room, endpoint: .add)!
                        var request = URLRequestBuilder().createRequest(method: .post, url: url, body: data)
                        request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                        networkService.sendDataGetResponseWithCodeOnly(request: request!)
                        print(networkService.statusCode)
                            
                        context.insert(roomItem)
                        dismiss()
                        
                        
                    }
                    
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
                
            }.navigationTitle("Add Room")
                .alert("Fill all fields", isPresented: $showAlert) {
                            Button("OK", role: .cancel) { }
                        }
            
            
                
        }
    }
}

#Preview {
    AddRoomSDView()
        .modelContainer(for: RoomModel.self)
}
