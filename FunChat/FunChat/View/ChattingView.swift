//
//  ChattingView.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import SwiftUI
import Starscream

struct ChattingView: View {
    @StateObject private var messageViewModel = MessageViewModel()
    @State var userName: String?
    @State private var message: String = ""
    @State private var isEditing = false
    @State private var isKeyboardShow = false
    @State private var sendUserInfo: UserInfo?
    @State private var receivedUserInfo: UserInfo?
    @State private var showAlert = false
    private var fromScene: Int32?
    let url = URL(string: "https://xhzq.xyz/23333")
//    private var messagesView: some View {
//
//
    }
    
    private var sendView: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                TextEditor(text: $message)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray))
                if message.isEmpty {
                    Text("Type a message")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                        .padding(.horizontal, 16)
                        .alignmentGuide(.leading) { _ in 0 }
                }
            }
            
            Spacer().frame(width: 8)
            
            Button{
                showAlert = message.isEmpty
                if !message.isEmpty {
                    sendMessage(content: message)
                }
            } label: {
                Text("send")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.black)
                    .padding(.vertical, 9.5)
                    .padding(.horizontal, 8.5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
            }.alert("Can't send an empty message! ",isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
        }.padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.white)
        .keyboardAwarePadding(isKeyboardShow: $isKeyboardShow)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Spacer().frame(width: 8)
                
                Text(receivedUserInfo?.name ?? "")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.black)
                    .lineLimit(1)
                Spacer()
                    
            }
            Spacer()
            sendView
        }
    }
    
    private func sendMessage(content: String) {
        messageViewModel.sendMessage(content: content, fromScene: fromScene)
    }
}

struct ChattingView_Previews: PreviewProvider {
    static var previews: some View {
        ChattingView()
    }
}
