//
//  ScheduleGroupsView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 15/02/2024.
//

import SwiftUI
import SwiftData

struct ScheduleGroupsView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @AppStorage("isDarkEnabled") private var isDarkEnabled = false
    @Environment(\.modelContext) var context
    @State private var showCreate = false
    @State private var showEdit = false
    @State private var groupToEdit: GroupModel?
    var scheduleID: UUID
    @Query private var groups: [GroupModel]
    init(for scheduleID: UUID) {
        self._groups = Query(filter: #Predicate{
            $0.scheduleID == scheduleID
        }, sort: [SortDescriptor(\GroupModel.groupName)])
        self.scheduleID = scheduleID
    }
    var body: some View {
        VStack{
            HStack{
                Text("Groups").font(.title)
                Spacer()
                Button("", systemImage: "plus") {
                    showCreate.toggle()
                }
            }
            .padding()
            List{
                ForEach(groups){ group in
                    GroupTileView(groupName: group.groupName, groupSize: group.groupSize, groupType: group.groupType.localizedName)
                        .swipeActions{
                            Button(role: .destructive) {
                                withAnimation {
                                    var url = URLRequestBuilder().createURL(route: .group, endpoint: .editDelete, parameter: group.id.uuidString)!
                                    print(url)
                                    var request = URLRequestBuilder().createRequest(method: .delete, url: url)
                                    request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                                    networkService.sendDataGetResponseWithCodeOnly(request: request!)
                                    
                                    context.delete(group)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                groupToEdit = group
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
                if groups.isEmpty {
                    ContentUnavailableView("No groups", systemImage: "person.2.slash.fill")
                }
            }
        }
        .sheet(isPresented: $showCreate, content: {
            AddGroupView(scheduleID: scheduleID)
        })
        .sheet(item: $groupToEdit) {
                        groupToEdit = nil
                    } content: { group in
                        EditGroupView(groupItem: group)
                    }
        .presentationDetents([.medium])
    }
}

#Preview {
    ScheduleGroupsView(for: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4")!)
        .modelContainer(for: GroupModel.self)
}
