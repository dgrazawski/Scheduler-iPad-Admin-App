//
//  EditScheduleView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/01/2024.
//

import SwiftUI
import SwiftData

struct EditScheduleView: View {
    @Bindable var schedule: ScheduleModel
    @State private var showQRSheet = false
    @State private var showClass = false
    
    var body: some View {
        VStack{
            
            if schedule.isCyclic {
                ScheduleGroupsView(for: schedule.id)
            } else {
                HStack {
                    ScheduleGroupsView(for: schedule.id)
                    MeetingsView(for: schedule.id)
                }
                
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Text("\(schedule.scheduleName) Year: \(schedule.year.rawValue)")
                    .font(.largeTitle)
                    .padding(.horizontal)
            }
            ToolbarItem(placement: .topBarTrailing) {
                    Button("Generate QR", systemImage: "qrcode") {
                        print("'placeholder for qr'")
                        showQRSheet.toggle()
                    }
                
                
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add classes", systemImage: "plus") {
                    showClass.toggle()
                }
            }
        }
        .sheet(isPresented: $showQRSheet, content: {
            GeneratedQRView(scheduleName: schedule.scheduleName, scheduleYear: schedule.year.rawValue, stringToGenerateCode: schedule.id.uuidString)
        })
        .sheet(isPresented: $showClass, content: {
            AddAllocationView()
        })
    }
}

#Preview(traits: .landscapeLeft) {
    
    NavigationStack {
        EditScheduleView(schedule: ScheduleModel(scheduleName: "Informatyka"))
            .modelContainer(for: [ScheduleModel.self, GroupModel.self, MeetingModel.self])
    }
}
