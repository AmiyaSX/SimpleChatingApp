//
//  MessageViewModel.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//
import Combine
import Foundation
import SwiftUI

class MessageViewModel: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    public var loadMessages: [MessageInfo] = []
    @Published public var receiveNewMessages: [Message] = []
    public var messageList: [Message] = []
    public var groups: [GroupInfo] = []
    public var group: GroupInfo?
    private var decoder = ApiClient.shared.decoder
    private var encoder = ApiClient.shared.encoder
    
    private let defaults = UserDefaults.standard
    
    private var toUid: Int64 = 0
    
    init() {
        
    }
    
    func sendMessage(message: Message) {
        messageList.append(message)
        didChange.send(())
    }
    
    func loadMessage(date: String, groupId: String) {
        let queryItems = [
            URLQueryItem(name: "history", value: date),
            URLQueryItem(name: "id", value: groupId)
        ]
        let request = ApiClient.shared.requestBuild(method: .get, suffix: Api.SUFFIX.MESSAGE, queryItems: queryItems)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) ->  Void  in
            if  error !=  nil {
                print (error.debugDescription)
            } else {
                do {
                    guard let jsonData = data else {
                        return
                    }
                    self.loadMessages = try
                    self.decoder.decode([MessageInfo].self, from: jsonData)
                    self.handleLoadMessage()
                    print(self.loadMessages)
                } catch {
                    print("Json数据转struct失败\(error)")
                }
            }
    }
        ).resume()
    }
    
    private func handleLoadMessage() {
        for msg in loadMessages {
            if !msg.IsImage {
                let isCrtUser = msg.Sender == self.defaults.integer(forKey: defaultKeys.id)
                messageList.append(Message(content: msg.Content, isCurrentUser: isCrtUser))
            } else {
                
            }
           
        }
    }
    
    private func notifyMessageListChanged(messageList: [MessageInfo]) {
        loadMessages = messageList
    }
    
    func getAllGroupsInfo() {
        let request = ApiClient.shared.requestBuild(method: .get, suffix: Api.SUFFIX.GROUPS)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) ->  Void  in
            if  error !=  nil {
                print (error.debugDescription)
            } else {
                do {
                    guard let jsonData = data else {
                        return
                    }
                    self.groups = try
                    self.decoder.decode([GroupInfo].self, from: jsonData)
                    print(self.groups)
                } catch {
                    print("Json数据转struct失败\(error)")
                }
           
            }
    }
        ).resume()
    }
    
    func getAllGroupsInfoById(userId: String) {
        let queryItems = [
            URLQueryItem(name: "id", value: userId),
        ]
        let request = ApiClient.shared.requestBuild(method: .get, suffix: Api.SUFFIX.GROUPS, queryItems: queryItems)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) ->  Void  in
            if  error !=  nil {
                print (error.debugDescription)
            } else {
                do {
                    guard let jsonData = data else {
                        return
                    }
                    self.group = try
                    self.decoder.decode(GroupInfo.self, from: jsonData)
                    print(self.group)
                } catch {
                    print("Json数据转struct失败\(error)")
                }
            }
    }
        ).resume()
    }
    
}
