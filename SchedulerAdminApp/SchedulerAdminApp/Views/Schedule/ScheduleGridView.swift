//
//  ScheduleGridView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 08/01/2024.
//c

import SwiftUI
import SwiftData

struct ScheduleGridView: View {
    @Environment(\.modelContext) var context
    @Query private var schedules: [ScheduleModel]
    @State private var showAddSchedule = false
    @State private var showDeleteAlert = false
    @State private var showSheet = false
    @State private var chosen: ScheduleModel?
    @State private var selectedScheduleID: UUID?
    let columns = [GridItem(.adaptive(minimum: 170, maximum: 170))]
    var body: some View {
        
        NavigationStack {
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20){
                    Button(action: {
                        showAddSchedule.toggle()
                    }, label: {
                        AddScheduleTileView()
                    })
                    ForEach(schedules, id: \.id){schedule in
                        ZStack {
                            NavigationLink(destination: EditScheduleView(schedule: schedule), isActive: Binding<Bool>(
                                get: { selectedScheduleID == schedule.id },
                                set: { _ in }
                            )) {
                                EmptyView()
                            }
                            .hidden()
                            .onAppear{
                                selectedScheduleID = nil
                            }
                                ScheduleTileView(title: schedule.scheduleName, year: String(schedule.year.rawValue))
                                .onTapGesture {
                                    showSheet.toggle()
                                    selectedScheduleID = schedule.id
                                }
                                .onLongPressGesture {
                                    withAnimation {
                                        showDeleteAlert.toggle()
                                        chosen = schedule
                                    }
                                }
                                .alert("Usunąć plan?!", isPresented: $showDeleteAlert) {
                                            Button("Delete", role: .destructive) {
                                                
                                                context.delete(chosen!)
                                                chosen = nil
                                            }
                            }
                        }
                    }
                }.sheet(isPresented: $showAddSchedule, content: {
                    AddScheduleView()
                })
                .sheet(isPresented: $showDeleteAlert) {
                    ScheduleDeleteView(scheduleID: chosen?.id ?? UUID())
                }
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    ScheduleGridView()
        .modelContainer(for: [RoomModel.self, ScheduleModel.self])
}
