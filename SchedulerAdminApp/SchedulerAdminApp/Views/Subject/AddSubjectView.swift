//
//  AddSubjectView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 06/01/2024.
//

import SwiftUI
import SwiftData

struct AddSubjectView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var subjectItem = SubjectModel()
    
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
                TextField("Exercise/Laboratory hours", text: $labHours.value)
                    .keyboardType(.numberPad)
                
                Button("Add Subject") {
                    if subjectName.isEmpty || hours.value.isEmpty || labHours.value.isEmpty {
                        showAlert = true
                    } else {
                        subjectItem.name = subjectName
                        subjectItem.learningYear = year
                        subjectItem.hours = Int(hours.value) ?? 0
                        subjectItem.labHours = Int(labHours.value) ?? 0
                        let data = try? JSONEncoder().encode(subjectItem)
                        var url = URLRequestBuilder().createURL(route: .subject, endpoint: .add)!
                        var request = URLRequestBuilder().createRequest(method: .post, url: url, body: data)
                        request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                        networkService.sendDataGetResponseWithCodeOnly(request: request!)
                        
                        context.insert(subjectItem)
                        dismiss()
                    }
                    
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Subject")
            .alert("Fill all fields", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
            
        }
    }
}

struct AddSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubjectView()
            .modelContainer(for: SubjectModel.self)
    }
}
