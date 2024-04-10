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
    @AppStorage("isDarkEnabled") private var isDarkEnabled = false
    @AppStorage("login") private var login: String = "admin"
    @AppStorage("password") private var password: String = "admin"
    @Environment(\.modelContext) var context
    @State private var showSplash: Bool = true
    @State private var loggedIn: Bool = false
    let modelContainer: ModelContainer
      init() {
        do {
            
            modelContainer = try ModelContainer(for: RoomModel.self, ScheduleModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, MeetingModel.self, CyclicTileModel.self, NonCyclicTileModel.self)
        } catch {
          fatalError("Could not initialize ModelContainer")
        }
      }
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !loggedIn {
                    LoginPageView(loggedIn: $loggedIn, savedPass: $login, savedLog: $password)
                } else {
                    MainView(logBool: $loggedIn)
                        .modelContainer(modelContainer)
                        .preferredColorScheme(isDarkEnabled ? .dark : .light)
                }
                if showSplash {
                    LaunchScreenView(showSplash: $showSplash)
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
}
