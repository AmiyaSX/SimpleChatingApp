//
//  LoginViewModel.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/8/6.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var isRegister: Bool = false
    @Published var isEnteringCode = false
    @Published var isCodeValid = true
    @Published var isEmailValid = false
    private var decoder = ApiClient.shared.decoder
    private var encoder = ApiClient.shared.encoder
    private let defaults = UserDefaults.standard
    var user: UserIdentify?
    
    init() {}
    
    func isUserRegister(email: String) -> Bool {
        ///todo send request
        return isRegister
    }
    
    func sendVerifyCode(email: String) {
        let queryItems = [
            URLQueryItem(name: "email", value: email),
        ]
        let request = ApiClient.shared.requestBuild(method: .get, suffix: Api.SUFFIX.VERIFY_CODE, queryItems: queryItems)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) ->  Void  in
            if  error !=  nil {
                print (error.debugDescription)
            } else {
                let  str =  String (data: data!, encoding:  String . Encoding .utf8)
                print (str ?? "verify code send succeeded")
            }
    }
        ).resume()
    }
    
    func userRegister(email: String, code: String) {
        let queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "code", value: code)
        ]
        let request = ApiClient.shared.requestBuild(method: .get, suffix: Api.SUFFIX.REGISTER, queryItems: queryItems)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) ->  Void  in
            if  error !=  nil {
                print (error.debugDescription)
            } else {
                let  str =  String (data: data!, encoding:  String . Encoding .utf8)
                print (str ?? "login")
                //TODO: 注册或重新登陆成功，更新本地token
                do {
                    guard let jsonData = data else {
                        return
                    }
                    self.user = try self.decoder.decode(UserIdentify.self, from: jsonData)
                    self.defaults.setValue(self.user?.Token, forKey: defaultKeys.token)
                    print(self.defaults.string(forKey: defaultKeys.token))
                    self.defaults.setValue(self.user?.ID, forKey: defaultKeys.id)
                    print(self.defaults.string(forKey: defaultKeys.id))
                    print(self.user)
                } catch {
                    print("login: Json数据转struct失败\(error)")
                }
            }
    }
        ).resume()
    }
    
    
}
