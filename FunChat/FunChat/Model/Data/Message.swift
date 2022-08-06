//
//  Message.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import Foundation
//定义消息类型结构
struct Message: Hashable {
    var content: String
    var isCurrentUser: Bool
//    var user: UserInfo
}

struct MessageInfo: Codable {
    let ID: Int
    let Group: Int
    let Sender: Int
    let Content: String
    let RepTo: Int
    let IsImage: Bool
    let Time: String
}
