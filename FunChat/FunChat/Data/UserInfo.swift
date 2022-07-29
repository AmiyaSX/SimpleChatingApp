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
    var token: String { get }
    var isLogin: Bool { get }
    var needRegister: Bool { get }
    
    func userRegister()
    func userLogout()
    
}
