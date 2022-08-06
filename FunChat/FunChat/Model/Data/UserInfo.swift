//
//  UserInfo.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/23.
//

import Foundation

public protocol UserApi: AnyObject {
    var name: String? { get }
    var uid: Int64 { get }
    var email: String { get }
    var isCurrentUser: Bool { get }
    
}


struct UserIdentify: Codable {
    let ID: Int64
    let Email: String
    let Token: String
    let Name: String
    let Banned: Bool
}

struct Account: Codable {
    let Email: String
    let Name: String
    let Banned: Bool
}

struct GroupInfo: Codable {
    let ID: Int32
    let Name: String
    let Accounts: [Account]
}

