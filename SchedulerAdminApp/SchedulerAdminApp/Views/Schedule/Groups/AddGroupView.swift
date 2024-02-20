//
//  AddGroupView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 15/02/2024.
//

import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var group: GroupModel = GroupModel()
    var scheduleID: UUID
    @State private var groupName: String = ""
    @State private var groupSize: StripToNumberService = StripToNumberService()
    @State private var groupType: GroupModel.GroupType = .lecture
    var body: some View {
        NavigationStack{
            Form{
                TextField("Group name", text: $groupName)
                TextField("Group size", text: $groupSize.value)
                Picker("Group type", selection: $groupType){
                    ForEach(GroupModel.GroupType.allCases){
                        group in
                        Text(group.localizedName).tag(group)
                    }
                }
                .pickerStyle(.menu)
                Button("Add Group"){
                    group.scheduleID = scheduleID
                    group.groupName = groupName
                    group.groupSize = Int(groupSize.value) ?? 0
                    group.groupType = groupType
                    context.insert(group)
                    dismiss()
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Group")
        }
        
    }
}

#Preview {
    AddGroupView(scheduleID: UUID(uuidString: "77e417cf-d6a4-4358-994a-885841361ad4") ?? UUID())
        .modelContainer(for: GroupModel.self)
}
