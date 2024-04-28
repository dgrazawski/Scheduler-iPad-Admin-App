//
//  DeleteScheduleView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/04/2024.
//

import SwiftUI
import SwiftData

struct DeleteScheduleView: View {
    @Bindable var schedule: ScheduleModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DeleteScheduleView(schedule: ScheduleModel())
        .modelContainer(for: [ScheduleModel.self, RoomModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, MeetingModel.self, CyclicTileModel.self, NonCyclicTileModel.self])
}
