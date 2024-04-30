//
//  ScheduleDeleteView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 27/04/2024.
//

import SwiftUI
import SwiftData

struct ScheduleDeleteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    let scheduleID: UUID
    var body: some View {
        NavigationStack{
            VStack{
                Text("Do you want to delete with all of connected groups, allocations and tiles?")
                HStack{
                    Button("NO"){
                        dismiss()
                    }
                    Button("YES"){
                        do {
                            try context.delete(model: GroupModel.self, where: #Predicate{
                                $0.scheduleID == scheduleID
                            })
                            try context.delete(model: AllocationModel.self, where: #Predicate{
                                $0.scheduleID == scheduleID
                            })
                            try context.delete(model: NonCyclicTileModel.self, where: #Predicate{
                                $0.scheduleID == scheduleID
                            })
                            try context.delete(model: CyclicTileModel.self, where: #Predicate{
                                $0.scheduleID == scheduleID
                            })
                            try context.delete(model: ScheduleModel.self, where: #Predicate{
                                $0.id == scheduleID
                            })
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        
                        dismiss()
                    }
                }
                .padding()
            }
            
        }
    }
}

#Preview {
    ScheduleDeleteView(scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4")!)
        .modelContainer(for: [ScheduleModel.self, RoomModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, MeetingModel.self, CyclicTileModel.self, NonCyclicTileModel.self])
}
