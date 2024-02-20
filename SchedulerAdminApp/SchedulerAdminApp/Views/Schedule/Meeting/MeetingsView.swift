//
//  MeetingsView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 20/02/2024.
//

import SwiftUI
import SwiftData

struct MeetingsView: View {
    @Environment(\.modelContext) var context
    @State private var showCreate = false
    @State private var showEdit = false
    @State private var meetingToEdit: MeetingModel?
    var scheduleID: UUID
    @Query private var meetings: [MeetingModel]
    init(for scheduleID: UUID) {
        self._meetings = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        }, sort: [SortDescriptor(\MeetingModel.startDate)])
        self.scheduleID = scheduleID
    }
    var body: some View {
        VStack{
            HStack{
                Text("Meetings").font(.title)
                Spacer()
                Button("", systemImage: "plus") {
                    showCreate.toggle()
                }
            }
            .padding()
            List{
                ForEach(meetings){meeting in
                    MeetingTileView(startDate: meeting.startDate, endDate: meeting.endDate)
                        .swipeActions{
                            Button(role: .destructive) {
                                withAnimation {
                                    context.delete(meeting)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button{
                                meetingToEdit = meeting
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
                if meetings.isEmpty {
                    ContentUnavailableView("No meetings", systemImage: "calendar.badge.exclamationmark")
                }
            }
        }
        .sheet(isPresented: $showCreate, content: {
            AddMeetingView(scheduleID: scheduleID)
        })
        .sheet(item: $meetingToEdit) {
                        meetingToEdit = nil
                    } content: { meeting in
                        EditMeetingView(meetingItem: meeting)
                    }
    }
}

#Preview {
    MeetingsView(for: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4")!)
        .modelContainer(for: MeetingModel.self)
}
