//
//  AddScheduleView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 10/01/2024.
//

import SwiftUI
import SwiftData

struct AddScheduleView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State private var schedule = ScheduleModel()
    var body: some View {
        
        NavigationStack {
            List{
                TextField("Plan's Name", text: $schedule.scheduleName)
                Picker("Year", selection: $schedule.year) {
                    ForEach(ScheduleModel.Year.allCases){
                        year in
                        Text(year.localizedName).tag(year)
                    }
                }
                Toggle(isOn: $schedule.isCyclic) {
                    Text("Is plan cyclic?")
                }
                Button("ADD plan"){
                    
                    let data = try? JSONEncoder().encode(schedule)
                    var url = URLRequestBuilder().createURL(route: .schedule, endpoint: .add)!
                    var request = URLRequestBuilder().createRequest(method: .post, url: url, body: data)
                    request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                    networkService.sendDataGetResponseWithCodeOnly(request: request!)
                    
                    context.insert(schedule)
                    
                    dismiss()
                }
                .foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("New Plan")
        }
    }
}

#Preview {
    AddScheduleView()
        .modelContainer(for: ScheduleModel.self)
}
