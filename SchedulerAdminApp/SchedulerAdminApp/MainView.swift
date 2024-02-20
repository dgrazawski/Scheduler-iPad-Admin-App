//
//  MainView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 10/01/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    enum TabsToChose: Int {
        case schedules = 1
        case lecturers = 2
        case subjects = 3
        case rooms = 4
        case options = 5
        
    }
    @State private var chosenTab: TabsToChose = .schedules
    
    var body: some View {
        TabView(selection: $chosenTab,
                content:  {
            ScheduleGridView().tabItem { Label("Schedules", systemImage: "list.bullet.rectangle.portrait.fill") }.tag(TabsToChose.schedules)
            LecturerView().tabItem { Label("Lecturers", systemImage: "person.2.fill") }.tag(TabsToChose.lecturers)
            SubjectView().tabItem { Label("Subjects", systemImage: "books.vertical.fill") }.tag(TabsToChose.subjects)
            RoomSDView().tabItem { Label("Rooms", systemImage: "key.fill") }.tag(TabsToChose.rooms)
            Text("Tu opcje").tabItem { Label("Settings", systemImage: "gear") }.tag(TabsToChose.options)
        })
        .toolbar(.visible, for: .tabBar)

    }
}

#Preview(traits: .landscapeLeft) {
    MainView()
        .modelContainer(for: ScheduleModel.self)
}
