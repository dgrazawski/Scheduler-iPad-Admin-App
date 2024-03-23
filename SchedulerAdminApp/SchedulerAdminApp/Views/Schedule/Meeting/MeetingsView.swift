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
    @Query(sort: \MeetingModel.startDate) private var meetings: [MeetingModel]
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
            AddMeetingView()
        })
        .sheet(item: $meetingToEdit) {
                        meetingToEdit = nil
                    } content: { meeting in
                        EditMeetingView(meetingItem: meeting)
                    }
    }
}

#Preview {
    MeetingsView()
        .modelContainer(for: MeetingModel.self)
}
