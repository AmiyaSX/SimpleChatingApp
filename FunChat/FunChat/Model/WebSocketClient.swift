//
//  WebSocketClient.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/8/7.
//

import Foundation
import Starscream
import UIKit
// MARK: - WebSocket代理
//这里即设置代理,稍后还会发通知.使用情况不一样.
protocol WebSocketClientDelegate: AnyObject {
    /// 建立连接成功通知
    func webSocketManagerDidConnect(manager: WebSocketClient)
    /// 断开链接通知,参数 `isReconnecting` 表示是否处于等待重新连接状态。
    func webSocketManagerDidDisconnect(manager: WebSocketClient, error: Error?)
    /// 接收到消息后的回调(String)
    func webSocketManagerDidReceiveMessage(manager: WebSocketClient, text: String)
    /// 接收到消息后的回调(Data)
    func webSocketManagerDidReceiveData(manager: WebSocketClient, data: Data)
}

enum WebSocketConnectType {
    case closed       //初始状态,未连接
    case connect      //已连接
    case disconnect   //连接后断开
    case reconnecting //重连中...
}

class WebSocketClient: NSObject {
    /// 单例,可以使用单例,也可以使用[alloc]init 根据情况自己选择
    static let shard = WebSocketClient()
    /// WebSocket对象
    private var webSocket : WebSocket?
    /// 是否连接
    var isConnected : Bool = false
    /// 代理
    weak var delegate: WebSocketClientDelegate?

    private var heartbeatInterval: TimeInterval = 5
    
    private let defaults = UserDefaults.standard
    
    let decoder = JSONDecoder()
    
    let encoder = JSONEncoder()
    
    /// 重连次数
    private var reConnectCount: Int = 0
    //存储要发送给服务端的数据,本案例不实现此功能,如有需求自行实现
    private var sendDataArray = [String]()
    

    ///心跳包定时器
    var heartBeatTimer: Timer?
    ///网络监听定时器
    var netWorkTimer:Timer?
    
    
    var connectType : WebSocketConnectType = .closed
    /// 用于判断是否主动关闭长连接，如果是主动断开连接，连接失败的代理中，就不用执行 重新连接方法
    private var isActivelyClose:Bool = false
    
    /// 当前是否有网络,应该由各自项目提供,本处为了方便,简历一个属性作为临时变量
    private var isHaveNet:Bool = true

    
    override init() {
//         webSocket.advancedDelegate = self

    }
    
    // MARK: - 公开方法,外部调用
    func connectSocket(_ paremeters: Any?) {
        guard let url = URL(string: Api.BASE_URL.baseWSUrl) else {
            return
        }

        self.isActivelyClose = false

        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        //添加头信息
        request.setValue("headers", forHTTPHeaderField: "Cookie")
        request.setValue("CustomeDeviceInfo", forHTTPHeaderField: "DeviceInfo")
        request.timeoutInterval = 20
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let token = defaults.string(forKey: defaultKeys.token) else {
            return
        }
        request.addValue(token, forHTTPHeaderField: "Authorization")
        guard let id = defaults.string(forKey: defaultKeys.id) else {
            return
        }
        request.addValue(id, forHTTPHeaderField: "ID")
        webSocket = WebSocket(request: request)
        webSocket?.delegate = self

        webSocket?.connect()
    }
    /// 发送消息
    func sendMessage(_ text: String, isImage: Bool?, repTo: Int32? = 0) {
        if self.isHaveNet {
            // 有网络直接发消息
            if self.connectType == .connect {  //已经连接
                //sender服务器那边有
                self.webSocket?.write(string: text)
            }else if self.connectType == .reconnecting {
                self.sendDataArray.append(text)
            }else if self.connectType == .disconnect {
                reConnectSocket()
            }else{
                self.sendDataArray.append(text)
            }
            
        } else {
            // 无网络的时候的操作
            //1.提示无网络
            //2.存储消息
            self.sendDataArray.append(text)
            //等待来网
            guard isActivelyClose else {
                return
            }
        }
    }
    /// 断开链接
    func disconnect() {
        self.isActivelyClose = true
        self.connectType = .disconnect
        webSocket?.disconnect()
    }
    /// 重新连接
    func reConnectSocket() {
        if self.reConnectCount > 10 { //重连10次
            self.reConnectCount = 0;
            return
        }
        //重连10次,每两次间隔5s
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if self.connectType == .reconnecting {
                return
            }
            /// 连接
            self.connectSocket(nil)
            self.reConnectCount = self.reConnectCount + 1
        }
    }
    
}

extension WebSocketClient: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
                  case .connected(let headers):
                      isConnected = true
                      delegate?.webSocketManagerDidConnect(manager: self)
                      
                      _ = "连接成功,在这里处理成功后的逻辑,比如将发送失败的消息重新发送等等..."
                      print("websocket is connected: \(headers)")
                      break
                  case .disconnected(let reason, let code):
                      isConnected = false
                      
                      let error = NSError(domain: reason, code: Int(code), userInfo: nil) as Error
                          delegate?.webSocketManagerDidDisconnect(manager: self, error: error)
                      
                      self.connectType = .disconnect
                      print("websocket is disconnected: \(reason) with code: \(code)")
                      break
                  case .text(let string):
                      delegate?.webSocketManagerDidReceiveMessage(manager: self, text: string)
                  
                   //当全局都需要数据时,这里使用通知.
                      let dic = ["text" : string]
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "webSocketManagerDidReceiveMessage"), object: dic)
                      print("Received text: \(string)")
                      break
                  case .binary(let data):
                      print("Received data: \(data.count)")
                      break
                  case .ping(_):
                      print("ping")
                      break
                  case .pong(_):
                      print("pong")
                      break
                  case .viabilityChanged(_):
                      break
                  case .reconnectSuggested(_):
                      break
                  case .cancelled:
                      isConnected = false
                  case .error(let error):
                      isConnected = false
                      handleError(error)
              }
          }
          
          // custom
          func handleError(_ error: Error?) {
              if let e = error as? WSError {
                  print("websocket encountered an error: \(e.message)")
              } else if let e = error {
                  print("websocket encountered an error: \(e.localizedDescription)")
              } else {
                  print("websocket encountered an error")
              }
          }
    
}
