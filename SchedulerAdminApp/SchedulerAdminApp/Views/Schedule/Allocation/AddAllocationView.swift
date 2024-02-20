//
//  AddAllocationView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import SwiftUI
import SwiftData

struct AddAllocationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query private var subjects: [SubjectModel]
    @Query private var lecturers: [LecturerModel]
    @Query private var groups: [GroupModel]
    @State private var lecturer: LecturerModel?
    @State private var subject: SubjectModel?
    @State private var group: GroupModel?
    var body: some View {
        NavigationStack{
            Form{
                Picker("Subject", selection: $subject){
                    ForEach(subjects){ subject in
                        Text(subject.name)
                    }
                }
                Picker("Lecturer", selection: $lecturer){
                    ForEach(lecturers){ lecturer in
                        VStack{
                            Text(lecturer.degree.localizedName)
                            Text("\(lecturer.lecturerName) \(lecturer.lecturerLastName)")
                        }
                    }
                }
                Picker("Groups", selection: $group){
                    ForEach(groups){ group in
                        VStack{
                            Text(group.groupName)
                            Text(group.groupType.localizedName)
                        }
                    }
                }
                Button("Add Classes") {
                    
                    
                    dismiss()
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add classes")
        }
    }
}

#Preview {
    AddAllocationView()
        .modelContainer(for: [ScheduleModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self])
}
