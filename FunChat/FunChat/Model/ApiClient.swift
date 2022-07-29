//
//  ApiClient.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/29.
//

import Foundation
import Starscream

public class ApiClient {
    public static let shared = ApiClient()
    var baseUrl: URL {
        let url = Api.baseUrl
    }
    
    private static let timeoutMS = 20_000
    private static let connectTimeoutS: TimeInterval = 20
    private static let RECONNECT_MAX_COUNT = 3 // 最多重连次数
    
    private var state = SocketConnectState.disConnect
    private var socket: WebSocket?
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func do
}
