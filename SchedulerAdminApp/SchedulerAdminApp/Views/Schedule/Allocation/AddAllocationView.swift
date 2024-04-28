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
    @Query private var rooms: [RoomModel]
    var scheduleID: UUID
    @State private var allocationItem: AllocationModel = AllocationModel()
    @State private var lecturer: LecturerModel?
    @State private var subject: SubjectModel?
    @State private var group: GroupModel?
    @State private var room: RoomModel?
    @State private var showAlert: Bool = false
    init(scheduleID: UUID){
        self.scheduleID = scheduleID
        self._groups = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        }, sort: [SortDescriptor(\GroupModel.groupName)])
        self._lecturer = State(initialValue: lecturers.first)
        self._subject = State(initialValue: subjects.first)
        self._group = State(initialValue: groups.first)
        self._room = State(initialValue: rooms.first)
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
                            Text("\(lecturer.degree.stringValue) \(lecturer.lecturerName) \(lecturer.lecturerLastName)")
                            .tag(Optional(lecturer))
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
                Button("Add Classes") {
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
                    if room!.roomSize < group!.groupSize {
                        showAlert.toggle()
                    } else {
                        allocationItem.room = room
                        allocationItem.group = group
                        allocationItem.subject = subject
                        allocationItem.lecturer = lecturer
                        room?.allocations.append(allocationItem)
                        group?.allocations.append(allocationItem)
                        subject?.allocations.append(allocationItem)
                        lecturer?.allocations.append(allocationItem)
                        
                        context.insert(allocationItem)
                        dismiss()
                    }
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
                    
            }
            .navigationTitle("Add classes")
            .alert("Can't create class", isPresented: $showAlert) {
                Text("The room is to small for the group")
                Button("OK") {
                    
                }
            }
        }
    }
}

#Preview {
    AddAllocationView(scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4") ?? UUID())
        .modelContainer(for: [ScheduleModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, RoomModel.self])
}
