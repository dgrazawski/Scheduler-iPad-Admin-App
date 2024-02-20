//
//  LecturerView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 07/01/2024.
//

import SwiftUI
import SwiftData


struct LecturerView: View {
    @Environment(\.modelContext) private var context
    @Query private var lecturers: [LecturerModel]
    
    @State private var selectedLecturer = Set<LecturerModel.ID>()
    
    @State private var sortOrder = [KeyPathComparator(\LecturerModel.lecturerName)]
    @State private var oneLecturer: LecturerModel?
    
    var sortedLecturers: [LecturerModel] {
        lecturers.sorted(using: sortOrder)
    }
    
    @State private var isSheet = false
    @State private var isEdit = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Table(sortedLecturers, selection: $selectedLecturer, sortOrder: $sortOrder){
                    TableColumn("Degree", value: \.degree){
                        value in
                        Text(value.degree.localizedName)
                    }
                    TableColumn("Name", value: \.lecturerName)
                    TableColumn("Last Name", value: \.lecturerLastName)
                    
                }
                .overlay{
                    if sortedLecturers.isEmpty {
                        ContentUnavailableView("No lecturers added", systemImage: "person.fill.xmark")
                    }
                }
                .onChange(of: sortOrder) {
                    sortedLecturers.sorted(using: $0)
                }
                HStack{
                    Text("\(lecturers.count) lecturers")
                    Spacer()
                    Text("\(selectedLecturer.count) lecturers selected")
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .navigationTitle("Lecturers")
            .sheet(isPresented: $isSheet) {
                AddLecturerView()
            }
            .sheet(isPresented: $isEdit, content: {
                EditLecturerView(lecturerItem: oneLecturer!)
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack{
                        Button {
                            isSheet.toggle()
                        } label: {
                            Label("Add Lecturer", systemImage: "plus")
                        }
                        Button {
                            for item in selectedLecturer{
                                if let index = sortedLecturers.firstIndex(where: {$0.id == item}){
                                    oneLecturer = sortedLecturers[index]
                                    isEdit.toggle()
                                    
                                }
                            }
                            selectedLecturer = Set<LecturerModel.ID>()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .disabled(selectedLecturer.count != 1)
                        Button {
                            for item in selectedLecturer{
                                if let index = sortedLecturers.firstIndex(where: {$0.id == item}){
                                    oneLecturer = sortedLecturers[index]
                                   
                                    context.delete(oneLecturer!)
                                }
                            }
                            selectedLecturer = Set<LecturerModel.ID>()
                        } label: {
                            Label("Delete selected lecturer", systemImage: "trash")
                        }


                    }
                }
            }
        }
    }
}

struct LecturerView_Previews: PreviewProvider {
    static var previews: some View {
        LecturerView()
            .previewInterfaceOrientation(.landscapeLeft)
            .modelContainer(for: LecturerModel.self)
    }
}
