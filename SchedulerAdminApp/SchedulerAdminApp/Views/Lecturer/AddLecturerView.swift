//
//  AddLecturerView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 07/01/2024.
//

import SwiftUI
import SwiftData

struct AddLecturerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var lecturerItem = LecturerModel()
    @State private var lecturerName: String = ""
    @State private var lecturerLastName: String = ""
    @State private var degree: LecturerModel.Degree = .doctor
    
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
                    lecturerItem.lecturerName = lecturerName
                    lecturerItem.lecturerLastName = lecturerLastName
                    lecturerItem.degree = degree //!! TRzeba to zmienic

                    context.insert(lecturerItem)

                    dismiss()
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Lecturer")
            
            
        }
    }
}

struct AddLecturerView_Previews: PreviewProvider {
    static var previews: some View {
        AddLecturerView()
            .modelContainer(for: LecturerModel.self)
    }
}