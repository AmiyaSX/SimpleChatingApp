//
//  ProfileView.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var messageViewModel: MessageViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var accountViewModel: AccountViewModel
    private var defaults = UserDefaults.standard
    @State private var showNameEdit = false
    @State private var userName = ""
    @State private var email = ""
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    showNameEdit = true
                }, label: {
                    Text("Name:  " + userName)
                        .font(.system(.title))
                })
                .popover(isPresented: $showNameEdit) {
                    VStack {
                        Text("Change name").font(.system(.subheadline)).foregroundColor(Color.gray)
                        TextField("Name: ", text: $userName, prompt: Text("Input Your Name"))
                            .padding(10)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                            .frame(height: 55)
                            .font(.system(size: 20, weight: .regular))
                            .frame(maxWidth: .infinity)
                            .frame(width: DisplayUtil.getScreenWidth()/1.8, height: 44, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondarySystemBackground))
                            .padding()
                        Button("Save", action: {
                            accountViewModel.changeAccountName(name: userName)
                            showNameEdit = false
                        }).foregroundColor(Color.white)
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 100, height: 44)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }.onTapGesture {
                        self.hideKeyboard()
                    }
                   
                }
                .padding()
            }.frame(alignment: .center)
            HStack {
                Text("Email:  " + email)
                    .font(.system(.subheadline))
                    .foregroundColor(Color.gray)
            }.frame(alignment: .center)
            Spacer()
        }.frame(alignment: .center)
        .environmentObject(loginViewModel)
        .onAppear() {
            userName = loginViewModel.user?.Name ?? "User11"
            email = loginViewModel.user?.Email ?? "428379791@qq.com"
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
