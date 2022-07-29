//
//  MessageManagerProtocol.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import Foundation

protocol MessageManagerProtocol {
    func sendMsg(msg: Message)
    func respondMsg(rMsgId: Int, msg: Message)
}

