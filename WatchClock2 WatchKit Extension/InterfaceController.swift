//
//  InterfaceController.swift
//  watchClock WatchKit Extension
//
//  Created by xwcoco@msn.com on 2018/11/8.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    @IBOutlet weak var scene: WKInterfaceSKScene!
    
    private var curWeatchIndex: Int = 0
    
    override func awake(withContext context: Any?) {
        //        print("awake")
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        loadWatchFromFiles()
        
        self.curWeatchIndex = UserDefaults.standard.integer(forKey: "CurWatchIndex")
        
        let watch = self.loadCurWatch()
        self.loadDefaultScene(watch: watch)
        
    }
    
    func loadDefaultScene(watch : WatchInfo?) {
        let tmpscene: WatchScene = WatchScene.init(fileNamed: "FaceScene")!
        tmpscene.initVars(watch)
        let currentDeviceSize: CGSize = WKInterfaceDevice.current().screenBounds.size
        tmpscene.camera?.xScale = (184.0 / currentDeviceSize.width);
        tmpscene.camera?.yScale = (184.0 / currentDeviceSize.width);
        scene.presentScene(tmpscene)
    }
    
    func loadCurWatch() -> WatchInfo? {
        if (self.WatchList.count == 0) {
            return nil
        }
        if (self.curWeatchIndex >= self.WatchList.count || self.curWeatchIndex < 0) {
            self.curWeatchIndex = 0
        }
        
        return WatchInfo.fromJSON(data: self.WatchList[self.curWeatchIndex])
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("willActivate")
        IPhoneSessionUtil.shareManager.delegate = self
        IPhoneSessionUtil.shareManager.StartSession()
        IPhoneSessionUtil.shareManager.NotifyWatchActived()
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func didAppear() {
        print("didAppear")
        let myApp = MyUIApplication()
        myApp.hideOSClock()
        
        self.crownSequencer.delegate = self
        self.crownSequencer.focus()
        
    }
    
    private var WatchList: [String] = []
    
    func loadWatchFromFiles() -> Void {
        let watchNum = UserDefaults.standard.integer(forKey: "WatchNum")
        //        let watchNum = 0
        print("watch Num is ", watchNum)
        self.WatchList.removeAll()
        for i in 0..<watchNum {
            if let str = UserDefaults.standard.string(forKey: "WatchData" + String(i)) {
                if (str != "") {
                    self.WatchList.append(str)
                }
            }
        }
    }
    
    func NextWatch(_ dire : Int) -> Void {
        if (self.WatchList.count > 1) {
            self.curWeatchIndex = self.curWeatchIndex + dire
            if (curWeatchIndex >= self.WatchList.count) {
                self.curWeatchIndex = 0
            }
            if (curWeatchIndex < 0) {
                curWeatchIndex = self.WatchList.count - 1
            }
            UserDefaults.standard.set(self.curWeatchIndex, forKey: "CurWatchIndex")
            let watch = self.loadCurWatch()
            self.loadDefaultScene(watch: watch)
        }
    }
    
    private func refreshWatchSettings() {
        self.loadWatchFromFiles()
        WatchSettings.reloadSettings()
        let watch = self.loadCurWatch()
        self.loadDefaultScene(watch: watch)
        //        let myScene = scene.scene as? WatchScene
        //        myScene?.beginUpdate()
        //        myScene?.initVars(watch)
        //        myScene?.endUpdate()
    }
    
    private var totalRotation: Double = 0
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        var direction : Int = 1;
        
        totalRotation += fabs(rotationalDelta);
        
        if (rotationalDelta < 0) {
            direction = -1;
        }
        
        
        if (totalRotation > (Double.pi / 4 / 2)) {
            self.NextWatch(direction)
            totalRotation = 0;
        }
        
    }
    
}

extension InterfaceController: IPhoneSesionDelegate {
    func onReciveMsg(message: [String: Any]) -> [String: Any]? {
        if (message.count > 0) {
            for (key, value) in message {
                UserDefaults.standard.set(value, forKey: key)
            }
        }
        self.refreshWatchSettings()
        return ["Watch":"设置已更新，本次更新 " + String(self.WatchList.count) + " 个手表"]
    }


}
