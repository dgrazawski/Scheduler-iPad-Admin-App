//
//  NoCycleAllocationPopView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 12/04/2024.
//

import SwiftUI
import SwiftData

struct NoCycleAllocationPopView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var tileItem: NonCyclicTileModel
    var tileColor: Color {
        switch(tileItem.tile?.group?.groupType.stringValue) {
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
    var createdName: String {
        var f: String =  tileItem.tile?.lecturer?.degree.stringValue ?? ""
        var m: String =    tileItem.tile?.lecturer?.lecturerName ?? ""
        var n: String = tileItem.tile?.lecturer?.lecturerLastName ?? ""
        return [f, m, n].flatMap({$0}).joined(separator: " ")
    }
    var body: some View {
        ZStack {
            Rectangle().fill(tileColor.gradient)
            VStack(alignment: .leading, spacing: 5){
                Button("Delete", systemImage: "trash") {
                    var url = URLRequestBuilder().createURL(route: .nonCyclic, endpoint: .editDelete, parameter: tileItem.nctID.uuidString)!
                    print(url)
                    var request = URLRequestBuilder().createRequest(method: .delete, url: url)
                    request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                    networkService.sendDataGetResponseWithCodeOnly(request: request!)
                    context.delete(tileItem)
                }
                .foregroundColor(.white)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                .padding(.horizontal)
                Text(tileItem.tile?.subject?.name ?? "")
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Text(createdName)
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                HStack(alignment: .center, spacing: 5) {
                    Text(tileItem.tile?.group?.groupName ?? "")
                    Spacer()
                    Text(tileItem.tile?.room?.roomNumber ?? "")
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
