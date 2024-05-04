//
//  EditMeetingView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 20/02/2024.
//

import SwiftUI
import SwiftData

struct EditMeetingView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var meetingItem: MeetingModel
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    var dateManipulator: DateManipulatorService = DateManipulatorService()
    var body: some View {
        NavigationStack{
            Form{
                DatePicker("Start Date", selection: $startDate,  displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, in: startDate...
                            ,displayedComponents: .date)
                Button("Edit Meeting"){
                    meetingItem.startDate = dateManipulator.changeStartDate(startDate: startDate)
                    meetingItem.endDate = dateManipulator.changeEndDate(endDate: endDate)
                    meetingItem.dateSpan = meetingItem.countSpan(startDate: startDate, endDate: endDate)
                    
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .iso8601
                    let data = try? encoder.encode(meetingItem)
                    var url = URLRequestBuilder().createURL(route: .meeting, endpoint: .editDelete, parameter: meetingItem.id.uuidString)!
                    print(url)
                    var request = URLRequestBuilder().createRequest(method: .put, url: url, body: data)
                    request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                    networkService.sendDataGetResponseWithCodeOnly(request: request!)
                    
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
            endDate = dateManipulator.changeEndDate(endDate: endDate)
            endDate = meetingItem.endDate
        }
    }
}

#Preview {
    EditMeetingView(meetingItem: MeetingModel())
        .modelContainer(for: MeetingModel.self)
}
