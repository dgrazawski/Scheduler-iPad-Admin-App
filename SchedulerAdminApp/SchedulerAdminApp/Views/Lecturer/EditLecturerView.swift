//
//  EditLecturerView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 11/02/2024.
//

import SwiftUI
import SwiftData

struct EditLecturerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var lecturerItem: LecturerModel
    
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
                
                Button("Edit Lecturer") {
                    if lecturerName.isEmpty || lecturerLastName.isEmpty {
                        showAlert = true
                    } else {
                        lecturerItem.lecturerName = lecturerName
                        lecturerItem.lecturerLastName = lecturerLastName
                        lecturerItem.degree = degree


                        dismiss()
                    }
                    
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Edit Lecturer")
            .alert("Fill all fields", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
        }
        .onAppear{
            lecturerName = lecturerItem.lecturerName
            lecturerLastName = lecturerItem.lecturerLastName
            degree = lecturerItem.degree
        }
    }
}

#Preview {
    EditLecturerView(lecturerItem: LecturerModel(lecturerName: "Andrzej", lecturerLastName: "Tandrzej", degree: .habilitated))
        .modelContainer(for: LecturerModel.self)
}
