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
    let ID: Int32
    let Group: Int32
    let Sender: Int32
    let Content: String
    let RepTo: Int32
    let IsImage: Bool
    let Time: String
}
