//
//  AllocationListView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 18/03/2024.
//

import SwiftUI
import SwiftData

struct AllocationListView: View {
    @Environment(\.modelContext) var context
    @State private var showCreate = false
    @State private var showEdit = false
    @State private var allocationToEdit: AllocationModel?
    let scheduleID: UUID
    @Query private var allocations: [AllocationModel]
    init(for scheduleID: UUID){
        self._allocations = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        })
        
        self.scheduleID = scheduleID
    }
    var body: some View {
        VStack{
            HStack{
                Text("Classes list").font(.title)
                Spacer()
                Button("", systemImage: "plus") {
                    showCreate.toggle()
                }
            }
            .padding()
            List{
                ForEach(allocations) { allocation in
                    AllocationListTileView(subjectName: allocation.subject?.name ?? "", lecturerName: (allocation.lecturer?.degree.stringValue ?? "") + " " + (allocation.lecturer?.lecturerLastName ?? "") ?? "", groupName: allocation.group?.groupName ?? "", roomNumber: allocation.room?.roomNumber ?? "", groupType: allocation.group?.groupType.stringValue ?? "")
                        .swipeActions{
                            Button(role: .destructive) {
                                withAnimation {
                                    
                                    context.delete(allocation)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                allocationToEdit = allocation
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)

                        }
                }
            }
            .background(.white)
            .scrollContentBackground(.hidden)
            .overlay{
                if allocations.isEmpty {
                    ContentUnavailableView("No classes created", systemImage: "list.bullet.clipboard.fill")
                }
            }
        }
        .sheet(isPresented: $showCreate, content: {
            AddAllocationView(scheduleID: scheduleID)
    })
        .sheet(item: $allocationToEdit) {
                        allocationToEdit = nil
                    } content: { allocation in
                        EditAllocationView(allocationItem: allocation, scheduleID: scheduleID)
                    }
        .presentationDetents([.medium])
    }
}

#Preview {
    AllocationListView(for: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4")!)
        .modelContainer(for: [ScheduleModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, RoomModel.self])
}
