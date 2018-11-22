//
//  IWatchSessionUtil.swift
//  watchClock
//
//  Created by xwcoco@msn.com on 2018/11/16.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity

protocol WatchSessionDelegate {
    func onWatchConneted() -> Void
    func OnWatchDisConneted() -> Void
    func onWatchReplay(dict : Dictionary<String, Any>) ->Void
    func onWatchError(error : Error) ->Void
    func onWatchMessage(message : [String : Any]) ->Void
}

class IWatchSessionUtil : NSObject,WCSessionDelegate {
    
    static let SessionManager : IWatchSessionUtil = IWatchSessionUtil()
    
    var delegate : WatchSessionDelegate?
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    func StartSession() -> Void {
        session?.delegate = self
        session?.activate()
    }
    
    private override init() {
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch is Connected")
        self.delegate?.onWatchConneted()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
         self.delegate?.OnWatchDisConneted()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        self.delegate?.OnWatchDisConneted()
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//
//    }
    
    func SendMessageToWatch(msgDict : Dictionary<String,Any>) -> Void {
        session?.sendMessage(msgDict, replyHandler: { (dict:Dictionary) in
            self.delegate?.onWatchReplay(dict: dict)
        }, errorHandler: { (error) in
            print(error)
            self.delegate?.onWatchError(error: error)
        })
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        self.delegate?.onWatchMessage(message: message)
    }
    
    
}
