//
//  ChattingView.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import SwiftUI
import Starscream

struct ChattingView: View {
    
    @StateObject private var messageViewModel =  MessageViewModel()
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @State var userName: String?
    @State private var typingMsg: String = ""
    @State private var isEditing = false
    @State private var isKeyboardShow = true
    @State private var showAlert = false
    @Binding var chattingPagePresented: Bool
    
    private var sendView: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                TextEditor(text: $typingMsg)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .cornerRadius(8)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.black)
                    .padding(1)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                if typingMsg.isEmpty {
                    Text("Type a message")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .padding(.horizontal, 10)
                        .alignmentGuide(.leading) { _ in 0 }
                }
            }
            Spacer().frame(width: 8)
            Button{
                showAlert = typingMsg.isEmpty
                if !typingMsg.isEmpty {
                    let message = Message(content: typingMsg, isCurrentUser: true)
                    sendMessage(message: message)
                }
            } label: {
                Text("send")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 9.5)
                    .padding(.horizontal, 8.5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
            }.alert("Can't send an empty message! ",isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
        }.padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer().frame(height: 8)
//                Text(messageViewModel.group?.Name ?? "Public")
//                    .font(.system(size: 18, weight: .bold))
//                    .lineLimit(1)
//                    .padding()
                Divider()
                Spacer()
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messageViewModel.messageList, id: \.self) {
                            msg in MessageItemView(crtMsg: msg)
                        }
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                    }
                    .scaleEffect(x: 1, y: -1, anchor: .center)
                }
                Spacer()
                Divider()
                sendView
            }
            .navigationBarItems(leading: Button(action: {
                chattingPagePresented = false
            }, label: {
                Image("icon_back")
            }))
            .navigationTitle(messageViewModel.group?.Name ?? "Title")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                getAllGroupsInfoById()
                loadHistoryMessage()
            }
            .onTapGesture(perform: {
                self.hideKeyboard()
            }).environmentObject(loginViewModel)
                .environmentObject(messageViewModel)
        }
       
    }
    
    private func sendMessage(message: Message) {
        messageViewModel.sendMessage(message: message)
        typingMsg = ""
    }
    
    private func loadHistoryMessage() {
        messageViewModel.loadMessage(date: "2100-06-29T18:47:20.925", groupId: "1")
    }
    
    private func getAllGroupsInfoById() {
        guard let userId = UserDefaults.standard.string(forKey: "id") else {
            return
        }
        messageViewModel.getAllGroupsInfoById(userId: userId)
    }
}
