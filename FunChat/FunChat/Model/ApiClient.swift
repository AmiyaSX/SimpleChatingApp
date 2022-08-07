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
    
    let urlbase = URL(string: Api.BASE_URL.baseUrl)

    private let defaults = UserDefaults.standard

    private var socket: WebSocket?
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func requestBuild(method: Method, suffix: String, queryItems: [URLQueryItem]? = nil) -> URLRequest {
        var component = URLComponents(string: Api.BASE_URL.baseUrl + suffix)
        component?.queryItems = queryItems
        var request = URLRequest(url: (component?.url)!)
        switch method {
        case .get:
            request.httpMethod = "GET"
        case .post:
            request.httpMethod = "POST"
        case .put:
            request.httpMethod = "PUT"
        }
        request.timeoutInterval = 20
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let token = defaults.string(forKey: defaultKeys.token) else {
            return request
        }
        print(defaults.string(forKey: defaultKeys.token))
        request.addValue(token, forHTTPHeaderField: "Authorization")
        guard let id = defaults.string(forKey: defaultKeys.id) else {
            return request
        }
        print(defaults.string(forKey: defaultKeys.id))
        request.addValue(id, forHTTPHeaderField: "ID")
        return request
    }
}
