//
//  EditAllocationView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 19/03/2024.
//

import SwiftUI
import SwiftData

struct EditAllocationView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Bindable var allocationItem: AllocationModel
    var scheduleID: UUID
    
    @Query private var subjects: [SubjectModel]
    @Query private var lecturers: [LecturerModel]
    @Query private var groups: [GroupModel]
    @Query private var rooms: [RoomModel]
    
    @State private var lecturer: LecturerModel?
    @State private var subject: SubjectModel?
    @State private var group: GroupModel?
    @State private var room: RoomModel?
    
    init(allocationItem: AllocationModel, scheduleID: UUID) {
        self.scheduleID = scheduleID
        self.allocationItem = allocationItem
        self._groups = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        }, sort: [SortDescriptor(\GroupModel.groupName)])
    }
    var body: some View {
        NavigationStack{
            Form{
                Picker("Subject", selection: $subject){
                    ForEach(subjects){ subject in
                        Text(subject.name)
                            .tag(Optional(subject))
                    }
                }
                Picker("Lecturer", selection: $lecturer){
                    ForEach(lecturers){ lecturer in
                            Text("\(lecturer.degree.stringValue) \(lecturer.lecturerName) \(lecturer.lecturerLastName)").tag(Optional(lecturer))
                    }
                }
                Picker("Groups", selection: $group){
                    ForEach(groups){ group in
                        Text(group.groupName + " " + group.groupType.stringValue).tag(Optional(group))
                    }
                }
                Picker("Rooms", selection: $room){
                    ForEach(rooms){ room in
                        Text(room.roomNumber + " \(room.roomSize)")
                            .tag(Optional(room))
                    }
                }
                Button("Edit Classes") {
                    allocationItem.scheduleID = scheduleID
                    allocationItem.lecturerID = lecturer?.id ?? UUID()
                    allocationItem.groupID = group?.id ?? UUID()
                    allocationItem.subjectID = subject?.id ?? UUID()
                    allocationItem.roomID = room?.id ?? UUID()
                    allocationItem.lecturerName = "\(lecturer?.degree.stringValue ?? "") \(lecturer?.lecturerName ?? "") \(lecturer?.lecturerLastName ?? "")"
                    allocationItem.groupName = group?.groupName ?? ""
                    allocationItem.groupType = group?.groupType.stringValue ?? ""
                    allocationItem.subjectName = subject?.name ?? ""
                    allocationItem.roomName = room?.roomNumber ?? ""
                    
                    dismiss()
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Edit classes")
        }
        .onAppear{
            lecturer = lecturers.filter { $0.id == allocationItem.lecturerID}.first
            subject = subjects.filter { $0.id == allocationItem.subjectID}.first
            group = groups.filter { $0.id == allocationItem.groupID}.first
            room = rooms.filter { $0.id == allocationItem.roomID}.first
        }
    }
}

#Preview {
    EditAllocationView(allocationItem: AllocationModel(), scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4") ?? UUID())
        .modelContainer(for: [ScheduleModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, RoomModel.self])
}
