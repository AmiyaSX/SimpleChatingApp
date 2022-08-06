//
//  Api.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/28.
//

import Foundation
import Starscream

struct Api {
    struct BASE_URL {
        static let baseUrl = "https://xhzq.xyz:23333/"
        static let imageBaseUrl = "https://image.xhzq.xyz/"
        static let baseWSUrl = "wss://xhzq.xyz:23333/"
        static let imageWSBaseUrl = "wss://image.xhzq.xyz/"
    }

    struct SUFFIX {
        static let REGISTER = "register"
        static let VERSION = "version"
        static let VERIFY_CODE = "code"
        static let GROUPS = "groups"
        static let MESSAGE = "messages"
        static let LOGIN = "login"
        static let ACCOUNT = "account"
    }
}


public enum Method {
    case get
    case post
    case put
}

public enum SocketConnectState {
    case disConnect
    case connecting
    case connected
}

struct defaultKeys {
    static let name = "name"
    static let token = "token"
    static let id = "id"
}
