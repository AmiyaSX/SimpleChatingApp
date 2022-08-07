//
//  ContentView.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var messageViewModel =  MessageViewModel()
    @StateObject private var loginViewModel =  LoginViewModel()
    @StateObject private var accountViewModel = AccountViewModel()
    
    var body: some View {
        ZStack {
            LoginView()
        }
        .environmentObject(messageViewModel)
        .environmentObject(loginViewModel)
        .environmentObject(accountViewModel)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
