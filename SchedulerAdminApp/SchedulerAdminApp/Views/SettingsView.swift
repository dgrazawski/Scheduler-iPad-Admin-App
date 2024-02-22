//
//  SettingsView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/02/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkEnabled") private var isDarkEnabled = false
    @Binding var isLogged: Bool
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var isDark: Bool = false
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Change password")){
                    SecureField("Old password", text: $oldPassword)
                    SecureField("New password", text: $newPassword)
                    Button(action: {
                        print("change pass placeholder")
                    }, label: {
                        Text("Change password")
                    })
                    .foregroundColor(Color(.white))
                        .textCase(.uppercase)
                        .buttonStyle(.borderedProminent)
                }
                
                Toggle("Dark mode", isOn: $isDarkEnabled)
                
            }
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Log out"){
                        isLogged = false
                    }
                    .foregroundColor(Color(.white))
                        .textCase(.uppercase)
                        .buttonStyle(.borderedProminent)
                }
            })
        }
    }
}

#Preview(traits: .landscapeLeft) {
    SettingsView(isLogged: .constant(true))
}
