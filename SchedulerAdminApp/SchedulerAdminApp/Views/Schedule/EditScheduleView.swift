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
    
    var body: some View {
        ScrollView {
            VStack{

                HStack {
                    ScheduleGroupsView(for: schedule.id)
                    AllocationListView(for: schedule.id)
                }
                .frame(minHeight: 500)
                    Divider()
                if schedule.isCyclic {
                    DisplayCycleWeekPlanView(scheduleID: schedule.id)
                } else {
                    DisplayNonCycleWeekView(scheduleID: schedule.id)
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
            }
            .sheet(isPresented: $showQRSheet, content: {
                GeneratedQRView(scheduleName: schedule.scheduleName, scheduleYear: schedule.year.rawValue, stringToGenerateCode: schedule.id.uuidString)
            })
            
        }
    }
}

#Preview(traits: .landscapeLeft) {
    
    NavigationStack {
        EditScheduleView(schedule: ScheduleModel(scheduleName: "Informatyka"))
            .modelContainer(for: [ScheduleModel.self, GroupModel.self, MeetingModel.self, AllocationModel.self, CyclicTileModel.self, NonCyclicTileModel.self])
    }
}
