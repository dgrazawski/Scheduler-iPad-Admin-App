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
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var dateRange: [Date] = []
    private var dateManipulator: DateManipulatorService = DateManipulatorService()
    var body: some View {
        NavigationStack{
            Form{
                DatePicker("Start Date", selection: $startDate,  displayedComponents: .date)
                    
                DatePicker("End Date", selection: $endDate, in: startDate...
                            ,displayedComponents: .date)
                
                Button("Add Meeting"){
                    meeting.startDate = dateManipulator.changeStartDate(startDate: startDate)
                    meeting.endDate = dateManipulator.changeEndDate(endDate: endDate)
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
    AddMeetingView()
        .modelContainer(for: MeetingModel.self)
}
