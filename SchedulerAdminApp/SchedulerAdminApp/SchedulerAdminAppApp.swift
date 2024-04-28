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
    @AppStorage("x-access-token") private var token: String?
    @AppStorage("isDarkEnabled") private var isDarkEnabled = false
    @AppStorage("login") private var login: String = "admin"
    @AppStorage("password") private var password: String = "admin"
    @Environment(\.modelContext) var context
    @State private var showSplash: Bool = true
    @State private var loggedIn: Bool = false
    @State private var firstShow: Bool = false
    let modelContainer: ModelContainer
      init() {
        do {
            
            modelContainer = try ModelContainer(for: AccountModel.self, RoomModel.self, ScheduleModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, MeetingModel.self, CyclicTileModel.self, NonCyclicTileModel.self)
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
                    MainView(logBool: $loggedIn, firstShow: $firstShow)
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
