//
//  NoCycleAllocationPopView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 12/04/2024.
//

import SwiftUI
import SwiftData

struct NoCycleAllocationPopView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var tileItem: NonCyclicTileModel
    var tileColor: Color {
        switch(tileItem.tile?.groupType) {
        case "Lecture":
            return .blue
        case "Exercise":
            return .red
        case "Laboratories":
            return .cyan
        case "Seminary":
            return .green
        case "Special":
            return .mint
        default:
            return .yellow
        }
    }
    var body: some View {
        ZStack {
            Rectangle().fill(tileColor.gradient)
            VStack(alignment: .leading, spacing: 5){
                Button("Delete", systemImage: "trash") {
                    context.delete(tileItem)
                }
                .foregroundColor(.white)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                .padding(.horizontal)
                Text(tileItem.tile?.subjectName ?? "")
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Text(tileItem.tile?.lecturerName ?? "")
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                HStack(alignment: .center, spacing: 5) {
                    Text(tileItem.tile?.groupName ?? "")
                    Spacer()
                    Text(tileItem.tile?.roomName ?? "")
                }
                .padding(.horizontal)
                       
            }
            
        }
        .frame(maxWidth: 300, maxHeight: 200)
        .cornerRadius(15)
    }
}

#Preview {
    NoCycleAllocationPopView(tileItem: NonCyclicTileModel())
        .modelContainer(for: [AllocationModel.self, NonCyclicTileModel.self])
}
