//
//  EditSubjectView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 10/02/2024.
//

import SwiftUI
import SwiftData

struct EditSubjectView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var subjectItem: SubjectModel
    
    @State private var subjectName: String = ""
    @State private var year: SubjectModel.LearningYear = .first
    @State private var hours = StripToNumberService()
    @State private var labHours = StripToNumberService()
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack{
            Form{
                TextField("Subject name", text: $subjectName)
                Picker("Year:", selection: $year) {
                    ForEach(SubjectModel.LearningYear.allCases){
                        year in
                        Text(year.localizedName).tag(year)
                    }
                }
                .pickerStyle(.menu)
                TextField("Lecture hours", text: $hours.value)
                    .keyboardType(.numberPad)
                
                TextField("Exercise/Lab hours", text: $labHours.value)
                    .keyboardType(.numberPad)
                
                Button("Edit Subject") {
                    if subjectName.isEmpty || hours.value.isEmpty || labHours.value.isEmpty {
                        showAlert = true
                    } else {
                        subjectItem.name = subjectName
                        subjectItem.learningYear = year
                        subjectItem.hours = Int(hours.value) ?? 0
                        subjectItem.labHours = Int(labHours.value) ?? 0
                        
                        dismiss()
                    }
                    
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Edit Subject")
            .alert("Fill all fields", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
        }
        .onAppear{
            subjectName = subjectItem.name
            year = subjectItem.learningYear
            hours.value = String(subjectItem.hours)
            labHours.value = String(subjectItem.labHours)
            
        }
    }
}

#Preview {
    EditSubjectView(subjectItem: SubjectModel(name: "Infa", learningYear: .second, hours: 5, labHours: 3))
        .modelContainer(for: SubjectModel.self)
}
