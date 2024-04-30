//
//  EditGroupView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 16/02/2024.
//

import SwiftUI
import SwiftData

struct EditGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var groupItem: GroupModel
    @State private var groupName: String = ""
    @State private var groupSize: StripToNumberService = StripToNumberService()
    @State private var groupType: GroupModel.GroupType = .lecture
    @State private var showAlert: Bool = false
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
                Button("Edit Group"){
                    if groupName.isEmpty || groupSize.value.isEmpty {
                        showAlert = true
                    } else {
                        groupItem.groupName = groupName
                        groupItem.groupSize = Int(groupSize.value) ?? 0
                        groupItem.groupType = groupType
                        
                        dismiss()
                    }
                    
                }.foregroundColor(Color(.white))
                    .textCase(.uppercase)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Edit Group")
            .alert("Fill all fields", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
        }
        .onAppear{
            groupName = groupItem.groupName
            groupSize.value = String(groupItem.groupSize)
            groupType = groupItem.groupType
        }
    }
}

#Preview {
    EditGroupView(groupItem: GroupModel(groupName: "Group 1", groupSize: 5, groupType: .laboratories))
        .modelContainer(for: GroupModel.self)
}
