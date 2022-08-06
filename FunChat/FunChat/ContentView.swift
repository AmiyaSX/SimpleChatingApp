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

    var body: some View {
        ZStack {
            LoginView()
        }
        .environmentObject(loginViewModel)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
