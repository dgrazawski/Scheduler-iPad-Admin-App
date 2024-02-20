//
//  AddMeetingView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 20/02/2024.
//

import SwiftUI
import SwiftData

struct AddMeetingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var meeting: MeetingModel = MeetingModel()
    var scheduleID: UUID
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var dateRange: [Date] = []
    var body: some View {
        NavigationStack{
            Form{
                DatePicker("Start Date", selection: $startDate,  displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, in: startDate...
                            ,displayedComponents: .date)
                Button("Add Meeting"){
                    meeting.scheduleID = scheduleID
                    meeting.startDate = startDate
                    meeting.endDate = endDate
                    meeting.dateSpan = meeting.countSpan(startDate: startDate, endDate: endDate)
                    context.insert(meeting)
                    dismiss()
                }
                .foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Meeting")
        }
    }
}

#Preview {
    AddMeetingView(scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4") ?? UUID())
        .modelContainer(for: MeetingModel.self)
}
