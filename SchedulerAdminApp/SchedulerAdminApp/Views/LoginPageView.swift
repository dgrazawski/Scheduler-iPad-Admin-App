//
//  LoginPageView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/02/2024.
//

import SwiftUI

struct LoginPageView: View {
    @AppStorage("x-access-token") private var accessToken: String?
    @Binding var loggedIn: Bool
    @Binding var savedPass: String
    @Binding var savedLog: String
    @State private var login: String = "przyklad3"
    @State private var password: String = "password"
    @State private var wrongAlert: Bool = false
    private var buttonStatus: Bool {
        if login.count < 4 || password.count < 3 {
            return true
        }
        return false
    }
    @State private var showRegister: Bool = false
    
    var body: some View {
        ZStack{
            Color(.launchBackground)
                .ignoresSafeArea()
            VStack{
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                Text("Scheduler")
                    .font(.system(size: 40, design: .rounded))
                    .padding(.bottom)
                TextField("Login", text: $login)
                    .autocapitalization(.none)
                    .padding()
                    .background()
                    .cornerRadius(15)
                SecureField("Password", text: $password)
                    .padding()
                    .background()
                    .cornerRadius(15)
                    .padding(.bottom)
                
                Button(action: {
                    loginUser(username: login, password: password) { result in
                        switch result {
                        case .success(let token):
                            print("Received token: \(token)")
                            accessToken = token
                            loggedIn = true
                        case .failure(let error):
                            print("Error logging in: \(error.localizedDescription)")
                            wrongAlert.toggle()
                        }
                    }
//                    if ((token?.isEmpty) != nil) {
//                        wrongAlert.toggle()
//                    } else {
//                        loggedIn = true
//                    }
//                    if login == savedLog && password == savedPass {
//                        loggedIn = true
//                    } else {
//                        wrongAlert.toggle()
//                    }
                }, label: {
                    Text("Sign In")
                })
                .buttonStyle(.borderedProminent)
                .disabled(buttonStatus)
                .padding(.bottom)
                Button(action: {
                    showRegister.toggle()
                }, label: {
                    Text("Sign Up for new account")
                })
                .padding(.vertical)
            }
            .padding([.leading, .trailing])
            .frame(width: 500)
        }
        .sheet(isPresented: $showRegister, content: {
            RegisterView()
        })
        .alert("Wrong login or password!", isPresented: $wrongAlert) {
            Button("OK", role: .cancel) {
                password = ""
            }
        }
    }
}

func loginUser(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
    let url = URLRequestBuilder().createURL(route: .account, endpoint: .login)!
    
    let loginData = LoginData(username: username, password: password)
    let data = try? JSONEncoder().encode(loginData)
    let request = URLRequestBuilder().createRequest(method: .post, url: url, body: data)!
//    var service = NetworkService(url: url, request: request)
    var service = NetworkService()
    var token: String = ""
    service.proba2(request: request)
        .decode(type: Token.self, decoder: JSONDecoder())
        .sink { (completion) in
            switch completion {
            case .finished:
                print("success")
            case .failure(let error):
                print("error \(error)")
                
            }
        } receiveValue: { (response) in
            completion(.success(response.token))
        }
        .store(in: &service.cancellables)
    
    print(token)
}
#Preview(traits: .landscapeLeft) {
    LoginPageView(loggedIn: .constant(false), savedPass: .constant("admin"), savedLog: .constant("admin"))
}
