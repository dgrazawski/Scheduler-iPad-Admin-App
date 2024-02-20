//
//  EditMeetingView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 20/02/2024.
//

import SwiftUI
import SwiftData

struct EditMeetingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var meetingItem: MeetingModel
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    var body: some View {
        NavigationStack{
            Form{
                DatePicker("Start Date", selection: $startDate,  displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, in: startDate...
                            ,displayedComponents: .date)
                Button("Edit Meeting"){
                    meetingItem.startDate = startDate
                    meetingItem.endDate = endDate
                    meetingItem.dateSpan = meetingItem.countSpan(startDate: startDate, endDate: endDate)
                    dismiss()
                }
                .foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Edit Meeting")
        }
        .onAppear{
            startDate = meetingItem.startDate
            endDate = meetingItem.endDate
        }
    }
}

#Preview {
    EditMeetingView(meetingItem: MeetingModel())
        .modelContainer(for: MeetingModel.self)
}
