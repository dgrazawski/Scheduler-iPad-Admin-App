//
//  MainView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 10/01/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @ObservedObject private var networkService: NetworkService =  NetworkService()
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
                    try context.delete(model: ScheduleModel.self)
                    
                } catch {
                    print("Didn't manage to clean local db")
                }
            }
            firstShow = false
            var urlRoom = URLRequestBuilder().createURL(route: .room, endpoint: .getAll)!
            var requestRoom = URLRequestBuilder().createRequest(method: .get, url: urlRoom)
            requestRoom?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getRooms(request: requestRoom!) {
                print("here is: \(networkService.rooms.count) rooms")
                networkService.rooms.forEach { room in
                    print("adding room")
                    context.insert(room)
                }
            }
            var urlSubject = URLRequestBuilder().createURL(route: .subject, endpoint: .getAll)!
            var requestSubject = URLRequestBuilder().createRequest(method: .get, url: urlSubject)
            requestSubject?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getSubjects(request: requestSubject!) {
                print("here is: \(networkService.subjects.count) subjects")
                networkService.subjects.forEach { subject in
                    print("adding subject")
                    context.insert(subject)
                }
            }
            var urlLecturer = URLRequestBuilder().createURL(route: .lecturer, endpoint: .getAll)!
            var requestLecturer = URLRequestBuilder().createRequest(method: .get, url: urlLecturer)
            requestLecturer?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getLecturers(request: requestLecturer!) {
                print("here is: \(networkService.lecturers.count) subjects")
                networkService.lecturers.forEach { lecturer in
                    context.insert(lecturer)
                }
            }
            var urlMeeting = URLRequestBuilder().createURL(route: .meeting, endpoint: .getAll)!
            var requestMeeting = URLRequestBuilder().createRequest(method: .get, url: urlMeeting)
            requestMeeting?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getMeetings(request: requestMeeting!) {
                print("here is: \(networkService.meetings.count) meetings")
                networkService.meetings.forEach { meeting in
                    meeting.dateSpan = meeting.countSpan(startDate: meeting.startDate, endDate: meeting.endDate)
                    context.insert(meeting)
                }
            }
            var urlSchedule = URLRequestBuilder().createURL(route: .schedule, endpoint: .getAll)!
            var requestSchedule = URLRequestBuilder().createRequest(method: .get, url: urlSchedule)
            requestSchedule?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getSchedules(request: requestSchedule!) {
                print("here is: \(networkService.schedules.count) meetings")
                networkService.schedules.forEach { schedule in
                    context.insert(schedule)
                }
            }
            var urlGroup = URLRequestBuilder().createURL(route: .group, endpoint: .getAll)!
            var requestGroup = URLRequestBuilder().createRequest(method: .get, url: urlGroup)
            requestGroup?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getGroups(request: requestGroup!) {
                print("here is: \(networkService.groups.count) groups")
                networkService.groups.forEach { group in
                    context.insert(group)
                }
            }
            var urlAllocation = URLRequestBuilder().createURL(route: .allocation, endpoint: .getAll)!
            var requestAllocation = URLRequestBuilder().createRequest(method: .get, url: urlAllocation)
            requestAllocation?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getAllocations(request: requestAllocation!) {
                print("here is: \(networkService.allocations.count) allocations")
                networkService.allocations.forEach { allocation in
                    var lecturer = networkService.lecturers.filter({$0.id == allocation.lecturerID}).first
                    var room = networkService.rooms.filter({$0.id == allocation.roomID}).first
                    var subject = networkService.subjects.filter({$0.id == allocation.subjectID}).first
                    var group = networkService.groups.filter({$0.id == allocation.groupID}).first
                    allocation.room = room
                    allocation.lecturer = lecturer
                    allocation.subject = subject
                    allocation.group = group
                   // context.insert(allocation)
                   room?.allocations.append(allocation)
                   lecturer?.allocations.append(allocation)
                   subject?.allocations.append(allocation)
                    group?.allocations.append(allocation)
                }
            }
            var urlNonCyclic = URLRequestBuilder().createURL(route: .nonCyclic, endpoint: .getAll)!
            var requestNonCyclic = URLRequestBuilder().createRequest(method: .get, url: urlNonCyclic)
            requestNonCyclic?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getNonCyclicTiles(request: requestNonCyclic!) {
                print("here is: \(networkService.nonCyclicTiles.count) non cyclic tiles")
                networkService.nonCyclicTiles.forEach { nonCyclicTile in
                    var allocation = networkService.allocations.filter({$0.id == nonCyclicTile.tileID}).first
                    nonCyclicTile.tile = allocation
                    allocation?.nonCyclicTiles.append(nonCyclicTile)
                }
            }
            var urlCyclic = URLRequestBuilder().createURL(route: .cyclic, endpoint: .getAll)!
            var requestCyclic = URLRequestBuilder().createRequest(method: .get, url: urlCyclic)
            requestCyclic?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
            networkService.getCyclicTiles(request: requestCyclic!) {
                print("here is: \(networkService.cyclicTiles.count) cyclic tiles")
                networkService.cyclicTiles.forEach { cyclicTile in
                    var allocation = networkService.allocations.filter({$0.id == cyclicTile.tileID}).first
                    cyclicTile.tile = allocation
                    allocation?.cyclicTiles.append(cyclicTile)
                }
            }
        }

    }
}

#Preview(traits: .landscapeLeft) {
    MainView(logBool: .constant(true), firstShow: .constant(true))
        .modelContainer(for: [ScheduleModel.self, RoomModel.self, SubjectModel.self, LecturerModel.self, GroupModel.self, AllocationModel.self, MeetingModel.self, CyclicTileModel.self, NonCyclicTileModel.self])
}
