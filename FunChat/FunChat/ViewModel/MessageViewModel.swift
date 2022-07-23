//
//  MessageViewModel.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//
import Combine
import Foundation
import SwiftUI

class MessageViewModel: ObservedObject {
    @Published public var loadMessages: [Message] = []
    @Published public var receiveNewMessages: [Message] = []
    private var messageList: [Message] = []
    private var messageMap: [String: Message] = [:]
    private var toUid: Int64 = 0
    init() {
        
    }
    
    func sendMessage(content: String, fromScene: Int32) {
        
    }
    
    func recieveMessage() {
        
    }

    private func notifyMessageListChanged(messageList: [Message]) {
        loadMessages = messageList
    }
}
