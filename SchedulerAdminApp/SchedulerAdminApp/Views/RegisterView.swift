//
//  RegisterView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/04/2024.
//

import SwiftUI
import SwiftData
import Combine

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var userName = ""
    @State private var password = ""
    @State private var email = ""
    @State private var universityName = ""
    @State private var facultyName = ""
    @State private var account: AccountModel = AccountModel()
    var body: some View {
        NavigationStack{
                Form{
                    TextField("Username", text: $userName)
                    TextField("Password", text: $password)
                    TextField("Email", text: $email)
                    TextField("University", text: $universityName)
                    TextField("Faculty", text: $facultyName)
                    Button("Register") {
                        account.username = userName
                        account.password = password
                        account.email = email
                        account.universityName = universityName
                        account.facultyName = facultyName
                        register(account: account)
                        dismiss()
                    }
                    .foregroundColor(Color(.white))
                        .textCase(.uppercase)
                        .buttonStyle(.borderedProminent)
                }
                .navigationTitle("Register new account")
        }
    }
}

func register(account: AccountModel) {
    var url: URL = URLRequestBuilder().createURL(route: .account, endpoint: .register)!
    
    print("tworzyURL")
    
     let data = try? JSONEncoder().encode(account)
    print("enkoduje")
    var request: URLRequest = URLRequestBuilder().createRequest(method: .post, url: url, body: data)!
    print("stworzył requesta \(String(describing: request.url))")
   var service = NetworkService(url: url, request: request)
    
    service.proba()
    
}

#Preview {
    RegisterView()
        .modelContainer(for: AccountModel.self)
}
