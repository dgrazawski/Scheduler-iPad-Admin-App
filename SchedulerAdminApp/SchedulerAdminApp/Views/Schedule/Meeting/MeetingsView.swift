//
//  MeetingsView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 20/02/2024.
//

import SwiftUI
import SwiftData

struct MeetingsView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @AppStorage("isDarkEnabled") private var isDarkEnabled = false
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
                                    var url = URLRequestBuilder().createURL(route: .meeting, endpoint: .editDelete, parameter: meeting.id.uuidString)!
                                    print(url)
                                    var request = URLRequestBuilder().createRequest(method: .delete, url: url)
                                    request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                                    networkService.sendDataGetResponseWithCodeOnly(request: request!)
                                    
                                    
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
            .background(isDarkEnabled ? .black : .white)
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
