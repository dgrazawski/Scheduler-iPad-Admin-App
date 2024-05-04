//
//  AddLecturerView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 07/01/2024.
//

import SwiftUI
import SwiftData

struct AddLecturerView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var lecturerItem = LecturerModel()
    @State private var lecturerName: String = ""
    @State private var lecturerLastName: String = ""
    @State private var degree: LecturerModel.Degree = .doctor
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack{
            Form{
                Picker("Degree:", selection: $degree) {
                    ForEach(LecturerModel.Degree.allCases) { degree in
                        Text(degree.localizedName).tag(degree)
                    }
                }
                .pickerStyle(.menu)
                TextField("Lecturer's Name", text: $lecturerName)
                TextField("Lecturer's Last Name", text: $lecturerLastName)
                
                Button("Add Lecturer") {
                    if lecturerName.isEmpty || lecturerLastName.isEmpty {
                        showAlert = true
                    } else {
                        lecturerItem.lecturerName = lecturerName
                        lecturerItem.lecturerLastName = lecturerLastName
                        lecturerItem.degree = degree //!! TRzeba to zmienic
                        
                        let data = try? JSONEncoder().encode(lecturerItem)
                        var url = URLRequestBuilder().createURL(route: .lecturer, endpoint: .add)!
                        var request = URLRequestBuilder().createRequest(method: .post, url: url, body: data)
                        request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                        networkService.sendDataGetResponseWithCodeOnly(request: request!)

                        context.insert(lecturerItem)

                        dismiss()
                    }
                    
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Lecturer")
            .alert("Fill all fields", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
            
        }
    }
}

struct AddLecturerView_Previews: PreviewProvider {
    static var previews: some View {
        AddLecturerView()
            .modelContainer(for: LecturerModel.self)
    }
}
