//
//  LoginPageView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/02/2024.
//

import SwiftUI

struct LoginPageView: View {
    @Binding var loggedIn: Bool
    @Binding var savedPass: String
    @Binding var savedLog: String
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var wrongAlert: Bool = false
    private var buttonStatus: Bool {
        if login.count < 4 || password.count < 4 {
            return true
        }
        return false
    }
    
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
                    if login == savedLog && password == savedPass {
                        loggedIn = true
                    } else {
                        wrongAlert.toggle()
                    }
                }, label: {
                    Text("Sign In")
                })
                .buttonStyle(.borderedProminent)
                .disabled(buttonStatus)
                .padding(.bottom)
                Button(action: {
                    print("placeholder sign up")
                }, label: {
                    Text("Sign Up for new account")
                })
                .padding(.vertical)
            }
            .padding([.leading, .trailing])
            .frame(width: 500)
        }
        .alert("Wrong login or password!", isPresented: $wrongAlert) {
            Button("OK", role: .cancel) {
                password = ""
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    LoginPageView(loggedIn: .constant(false), savedPass: .constant("admin"), savedLog: .constant("admin"))
}
