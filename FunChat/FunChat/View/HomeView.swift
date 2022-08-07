//
//  HomeView.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var messageViewModel =  MessageViewModel()
    @StateObject private var loginViewModel =  LoginViewModel()
    @StateObject private var accountViewModel = AccountViewModel()
    @State var selectIndex = INDEX_GROUP1_TAB
    @State var chattingPage1Presented: Bool = false
    @State var chattingPage2Presented: Bool = false
    @Binding var showHomePage: Bool
    
    var group1View = ChattingView(groupId: "2")
//    var group2View = ChattingView(groupId: "2")
    
    var profileView = ProfileView()
   
    var body: some View {
        NavigationView {
//        ZStack {
            TabBar(selection: $selectIndex) {
                group1View.tabBarItem(INDEX_GROUP1_TAB) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 8)
                            Image(selectIndex == INDEX_GROUP1_TAB ? "icon_ic_msg_filled" : "icon_ic_msg_b")
                            .resizable()
                            .frame(width: 24.0, height: 24.0)
                    }
                }
                
//                if let chattingPage2View = group2View {
//                    chattingPage2View.tabBarItem(INDEX_GROUP2_TAB) {
//                        VStack(spacing: 0) {
//                            Spacer().frame(height: 8)
//                                Image(selectIndex == INDEX_GROUP2_TAB ? "icon_ic_msg_filled" : "icon_ic_msg_b")
//                                .resizable()
//                                .frame(width: 24.0, height: 24.0)
//                        }
//                    }
//                }
                
                if let profileView = profileView {
                    profileView.tabBarItem(INDEX_PROFILE_TAB) {
                        VStack(spacing: 0) {
                            Spacer().frame(height: 8)
                                Image(selectIndex == INDEX_PROFILE_TAB ? "icon_ic_me_filled" : "icon_ic_me_b")
                                .resizable()
                                .frame(width: 24.0, height: 24.0)
                        }
                    }
                }
            }
//            }
        }.navigationBarHidden(true)
        .onAppear() {
            messageViewModel.loadHistoryMessage(groupId: "2")
        }
        .environmentObject(loginViewModel)
        .environmentObject(messageViewModel)
    }
}

