//
//  AccountViewModel.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/8/6.
//

import Foundation

class AccountViewModel: ObservableObject {
    
    private var decoder = ApiClient.shared.decoder
    private var encoder = ApiClient.shared.encoder
    
    func changeAccountName(name: String) {
        let queryItems = [
            URLQueryItem(name: "name", value: name),
        ]
        let request = ApiClient.shared.requestBuild(method: .put, suffix: Api.SUFFIX.ACCOUNT, queryItems: queryItems)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) ->  Void  in
            if  error !=  nil {
                print (error.debugDescription)
            } else {
                let  str =  String (data: data!, encoding:  String . Encoding .utf8)
                print (str ?? "aaaaaaa")
            }
    }
        ).resume()
    }
    
    func joinGroup(groupId: String) {
        let queryItems = [
            URLQueryItem(name: "id", value: groupId),
        ]
        let request = ApiClient.shared.requestBuild(method: .get, suffix: Api.SUFFIX.GROUPS, queryItems: queryItems)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) ->  Void  in
            if  error !=  nil {
                print (error.debugDescription)
            } else {
                let  str =  String (data: data!, encoding:  String . Encoding .utf8)
                print (str ?? "join")
            }
    }
        ).resume()
    }
    

}
