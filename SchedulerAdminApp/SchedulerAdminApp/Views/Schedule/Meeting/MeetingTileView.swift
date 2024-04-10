//
//  MeetingTileView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 20/02/2024.
//

import SwiftUI

struct MeetingTileView: View {
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    var startDate: Date
    var endDate: Date
    
    var body: some View {
        HStack{
            Label("", systemImage: "calendar.circle")
                .font(.largeTitle)
            Spacer()
            Text(formatter.string(from: startDate))
            Text(" - ")
            Text(formatter.string(from: endDate))
        }
        .padding(.horizontal)
        .font(.title2)
    }
}

#Preview {
    MeetingTileView(startDate: Date(), endDate: Date())
}
