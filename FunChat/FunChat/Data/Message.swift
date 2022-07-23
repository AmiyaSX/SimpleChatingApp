//
//  Message.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import Foundation
//定义消息类型结构
public class Message: Codable {
    
    private var uid: Int?
    
    private var content: String?
    
    func getUid() -> Int? {
        return self.uid
    }
    func setUid(_ uid: Int){
        self.uid = uid
    }
    func getContent() -> String? {
        return self.content
    }
    func setContent(_ content: String) {
        self.content = content
    }
}
