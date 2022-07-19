//
//  Message.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/7/19.
//

import Foundation
//定义消息类型结构
public class Message {
    private var uid: Int?
    private var text: String?
    
    func getUid() -> Int? {
        return self.uid
    }
    func setUid(_ uid: Int){
        self.uid = uid
    }
    func getText() -> String? {
        return self.text
    }
    func setText(_ text: String) {
        self.text = text
    }
}
