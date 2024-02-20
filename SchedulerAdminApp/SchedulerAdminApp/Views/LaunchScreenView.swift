//
//  LaunchScreenView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 18/02/2024.
//

import SwiftUI

struct LaunchScreenView: View {
    @Environment(\.dismiss) var dismiss
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @Binding var showSplash: Bool
    var body: some View {
        ZStack{
            Color(.launchBackground)
                .ignoresSafeArea()
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                .frame(width: 500, height: 500)
                Text("Scheduler")
                    .font(.system(size: 60, design: .rounded))
                    
            }
        }
        .onReceive(timer, perform: { _ in
            counter += 1
            print(counter)
            if counter >= 4 {
                showSplash = false
                dismiss()
                print(showSplash)
                
            }
        })
    }
}

#Preview(traits: .landscapeLeft) {
    LaunchScreenView(showSplash: .constant(true))
}
