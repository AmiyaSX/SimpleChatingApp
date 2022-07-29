//
//  Api.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/28.
//

import Foundation
import Starscream

struct Api {
    static let baseUrl = "https://xhzq.xyz:23333/"
    static let imageBaseUrl = "https://image.xhzq.xyz/"

    static let REGISTER = "register/"
    static let VERSION = "version/"
    static let VERIFY_CODE = "code/"
    static let GROUPS = "groups/"
    static let LOGIN = "login/"
    static let ACCOUNT = "account/"
    
}

public enum SocketConnectState {
    case disConnect
    case connecting
    case connected
}
