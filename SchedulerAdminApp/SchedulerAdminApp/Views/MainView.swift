//
//  MainView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 10/01/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    enum TabsToChose: Int {
        case schedules = 1
        case lecturers = 2
        case subjects = 3
        case rooms = 4
        case meetings = 5
        case options = 6
        
    }
    @State private var chosenTab: TabsToChose = .schedules
    @Binding var logBool: Bool
    @Binding var firstShow: Bool
    
    var body: some View {
        TabView(selection: $chosenTab,
                content:  {
            ScheduleGridView().tabItem { Label("Schedules", systemImage: "list.bullet.rectangle.portrait.fill") }.tag(TabsToChose.schedules)
            LecturerView().tabItem { Label("Lecturers", systemImage: "person.2.fill") }.tag(TabsToChose.lecturers)
            SubjectView().tabItem { Label("Subjects", systemImage: "books.vertical.fill") }.tag(TabsToChose.subjects)
            RoomSDView().tabItem { Label("Rooms", systemImage: "key.fill") }.tag(TabsToChose.rooms)
            MeetingsView().tabItem { Label("Meetings", systemImage: "calendar.badge.clock")}.tag(TabsToChose.meetings)
            SettingsView(isLogged: $logBool).tabItem { Label("Settings", systemImage: "gear") }.tag(TabsToChose.options)
        })
        .toolbar(.visible, for: .tabBar)
        .onAppear {
            if firstShow {
                do {
                    try context.delete(model: NonCyclicTileModel.self)
                    try context.delete(model: CyclicTileModel.self)
                    try context.delete(model: AllocationModel.self)
                    try context.delete(model: GroupModel.self)
                    try context.delete(model: MeetingModel.self)
                    try context.delete(model: LecturerModel.self)
                    try context.delete(model: RoomModel.self)
                    try context.delete(model: SubjectModel.self)
                    
                } catch {
                    print("Didn't manage to clean local db")
                }
            }
            
            
        }

    }
}

#Preview(traits: .landscapeLeft) {
    MainView(logBool: .constant(true), firstShow: .constant(true))
        .modelContainer(for: [ScheduleModel.self, RoomModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, MeetingModel.self, CyclicTileModel.self, NonCyclicTileModel.self])
}
