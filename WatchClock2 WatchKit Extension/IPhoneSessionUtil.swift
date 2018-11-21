//
//  IPhoneSessionUtil.swift
//  watchClock WatchKit Extension
//
//  Created by xwcoco@msn.com on 2018/11/16.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol IPhoneSesionDelegate {
    func onReciveMsg(message: [String: Any]) -> [String: Any]?
}
class IPhoneSessionUtil: NSObject, WCSessionDelegate {

    static var shareManager: IPhoneSessionUtil = IPhoneSessionUtil()

    private var session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    var delegate: IPhoneSesionDelegate?

    func StartSession() -> Void {
        self.session?.delegate = self
//        if self.session?.activationState != WCSessionActivationState.activated {
            self.session?.activate()
//        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationState = ",activationState)
        print(error)
    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        print(message)
//    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if let ret = self.delegate?.onReciveMsg(message: message) {
            replyHandler(ret)
        }

    }
    
    func NotifyWatchActived() -> Void {
        print("NotifyWatchActived")
        SendMessageToIPhone(message: ["Watch":"Actived"])
    }
    
    func SendMessageToIPhone(message : [String: Any]) -> Void {
//        print(self.session?.activationState)
        if (self.session?.activationState != WCSessionActivationState.activated) {
            print("message not send ...")
            return
        }
        self.session?.sendMessage(message, replyHandler: { ([String : Any]) in
            
        }, errorHandler: { (error) in
            print(error)
        })
    }


}
