//
//  SubjectView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 06/01/2024.
//

import SwiftUI
import SwiftData


struct SubjectView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @Environment(\.modelContext) var context
    @Query private var subjects: [SubjectModel]

    
    @State private var selectedSubject = Set<SubjectModel.ID>()
    
    @State private var sortOrder = [KeyPathComparator(\SubjectModel.name)]
    @State private var oneSubject: SubjectModel?
    
    var sortedSubjects: [SubjectModel] {
        subjects.sorted(using: sortOrder)
    }
    
    @State private var isSheet = false
    @State private var isEdit = false
    var body: some View {
        NavigationStack{
            VStack{
                Table(sortedSubjects, selection: $selectedSubject, sortOrder: $sortOrder){
                    
                    TableColumn("Subject Name", value: \.name)
                    TableColumn("Year", value: \.learningYear){
                        value in
                        Text(value.learningYear.localizedName)
                    }
                    TableColumn("Lecture hours", value: \.hours){
                        value in
                        Text("\(value.hours)")
                    }
                    TableColumn("Exercise/Lab hours", value: \.labHours){
                        value in
                        Text("\(value.labHours)")
                    }
                }
                .overlay{
                    if sortedSubjects.isEmpty {
                        ContentUnavailableView("No subjects added", systemImage: "books.vertical.fill")
                    }
                }
                .onChange(of: sortOrder) {
                    sortedSubjects.sorted(using: $0)
                }
                
                HStack{
                    Text("\(subjects.count) subjects")
                    Spacer()
                    Text("\(selectedSubject.count) subjects selected")
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .navigationTitle("Subjects")
            .sheet(isPresented: $isSheet) {
                AddSubjectView()
                    
            }
            .sheet(isPresented: $isEdit, content: {
                EditSubjectView(subjectItem: oneSubject!)
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack{
                        Button {
                            isSheet.toggle()
                        } label: {
                            Label("Add Subject", systemImage: "plus")
                        }
                        Button {
                            for item in selectedSubject{
                                if let index = sortedSubjects.firstIndex(where: {$0.id == item}){
                                    oneSubject = sortedSubjects[index]
                                    isEdit.toggle()
                                    
                                }
                            }
                            selectedSubject = Set<SubjectModel.ID>()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .disabled(selectedSubject.count != 1)
                        Button {
                            for item in selectedSubject{
                                if let index = sortedSubjects.firstIndex(where: {$0.id == item}){
                                    oneSubject = sortedSubjects[index]
                                    
                                    var url = URLRequestBuilder().createURL(route: .subject, endpoint: .editDelete, parameter: oneSubject?.id.uuidString ?? "")!
                                    print(url)
                                    var request = URLRequestBuilder().createRequest(method: .delete, url: url)
                                    request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                                    networkService.sendDataGetResponseWithCodeOnly(request: request!)
                                   
                                    context.delete(oneSubject!)
                                }
                            }
                            selectedSubject = Set<SubjectModel.ID>()
                        } label: {
                            Label("Delete selected room", systemImage: "trash")
                        }


                    }
                }
            }
        }
    }
}

struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectView()
            .previewInterfaceOrientation(.landscapeLeft)
            .modelContainer(for: SubjectModel.self)
    }
}
