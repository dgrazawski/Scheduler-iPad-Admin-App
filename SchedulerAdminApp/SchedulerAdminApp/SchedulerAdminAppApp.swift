//
//  SchedulerAdminAppApp.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 13/09/2023.
//

import SwiftUI
import SwiftData

@main
struct SchedulerAdminAppApp: App {
    @Environment(\.modelContext) var context
    @State private var showSplash = true
    let modelContainer: ModelContainer
      init() {
        do {
            
            modelContainer = try ModelContainer(for: RoomModel.self, ScheduleModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self)
        } catch {
          fatalError("Could not initialize ModelContainer")
        }
      }
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                    .modelContainer(modelContainer)
                if showSplash {
                    LaunchScreenView(showSplash: $showSplash)
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
}
