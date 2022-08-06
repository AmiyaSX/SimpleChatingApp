//
//  LoginView.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import SwiftUI
import Combine

struct LoginView: View {
    @State private var email: String = ""
    @State private var verifyCode: String = ""
    @State private var showAlert = false
    @State var chattingPagePresented: Bool = false
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text("Welcome To FunChat!")
                    .font(.system(.title))
                    .frame(height: 40)
                Spacer().frame(height: 100)
                Text(!loginViewModel.isEnteringCode ? "Please Input Your Email to Register or Login: " : "Please Input Verify Code: ")
                    .font(.system(size: 15, weight: .semibold)).padding()
                
                TextField(text: !loginViewModel.isEnteringCode ? $email : $verifyCode, prompt: Text(!loginViewModel.isEnteringCode ? " Email Address Required" : " Verify Code Required")) {
                   
                }
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .frame(width: loginViewModel.isEnteringCode ? DisplayUtil.getScreenWidth()/2 : DisplayUtil.getScreenWidth()/1.3, height: 44, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondarySystemBackground))
                    .onSubmit {
                        loginViewModel.isEnteringCode ? validate(code: verifyCode) : validate(email: email)
                        print(verifyCode)
                        print(email)
                    }
                
                if !loginViewModel.isEmailValid {
                    Text("invalid email address")
                        .foregroundColor(Color.red).font(.system(size: 10)).frame(height: 12, alignment: .leading)
                        
                }
                
                Button("Submit", action: {
                    ///todo: send register request
                    if loginViewModel.isEnteringCode {
                        //check code
                        loginViewModel.userRegister(email: email, code: verifyCode)
                        print("success Login")
                        loginViewModel.isCodeValid = true
                    } else {
                        guard validateEmail(email: email) else {
                            loginViewModel.isEmailValid = false
                            return
                        }
                        loginViewModel.isEmailValid = true
                        loginViewModel.sendVerifyCode(email: email)
                        showAlert = true
                    }
                }).foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 100, height: 44)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .alert("Register",isPresented: $showAlert, actions: {
                        Button("Confirm", action: {
                            loginViewModel.isEnteringCode = loginViewModel.isEmailValid
                        })
                        Button("Cancel", role: .cancel, action: { loginViewModel.isEnteringCode = false })
                    },message: {
                        if loginViewModel.isEnteringCode {
                            Text( loginViewModel.isCodeValid ? "Success!" : "Invalid Code!")
                        } else {
                            Text("The verify code is sended to your email box!")
                        }
                    })
                    .padding()
            }.frame(width: DisplayUtil.getScreenWidth(), height: DisplayUtil.getScreenHeight(), alignment: .center)
        }.fullScreenCover(isPresented: $chattingPagePresented, content: {
            ChattingView(chattingPagePresented: $chattingPagePresented).environmentObject(loginViewModel)
        })
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
        .onAppear() {
            chattingPagePresented = false
            email = "428379791@qq.com"
            loginViewModel.isEnteringCode = true
        }
        .onReceive(loginViewModel.$isCodeValid, perform: { _ in
            if loginViewModel.isCodeValid {
                chattingPagePresented = true
            }
        })
    }
    
    private func validate(email: String) {
        self.email = email
        
    }
    
    private func validate(code: String) {
        self.verifyCode = code
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return emailTest.evaluate(with: email)
    }
    
}

