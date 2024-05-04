//
//  SettingsView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/02/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("x-access-token") private var accessToken:String?
    @AppStorage("isDarkEnabled") private var isDarkEnabled = false
    @ObservedObject private var networkService: NetworkService =  NetworkService()
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
                        if !oldPassword.isEmpty && !newPassword.isEmpty {
                            print(accessToken ?? "No Token")
                            let changeData = ChangePassword(old_pass: oldPassword, new_pass: newPassword)
                            let data = try? JSONEncoder().encode(changeData)
                            var url = URLRequestBuilder().createURL(route: .account, endpoint: .changePass)!
                            var request = URLRequestBuilder().createRequest(method: .post, url: url, body: data)
                            request?.addValue(accessToken!, forHTTPHeaderField: "x-access-token")
                            networkService.sendDataGetResponseWithCodeOnly(request: request!)
                            
                        }
                        
                    }, label: {
                        Text("Change password")
                    })
                    .foregroundColor(Color(.white))
                        .textCase(.uppercase)
                        .buttonStyle(.borderedProminent)
                }
                
                Toggle("Dark mode", isOn: $isDarkEnabled)
                
            }
            .alert("Fill all fields", isPresented: $networkService.showAlert) {
                        Text(networkService.message ?? "x")
                        Button("OK", role: .cancel) { }
                    }
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Log out"){
                        isLogged = false
                        accessToken = nil
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
