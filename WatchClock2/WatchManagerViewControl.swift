//
//  WatchManagerViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/20.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchManagerViewControl: UITableViewController {


    private func updateWatch(index: Int) {
        if let cell = self.tableView.getCell(at: IndexPath.init(row: index, section: 0)) {
            if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                if let tmpscene = skview.scene as? WatchScene {
                    if let watch = WatchInfo.fromJSON(data: self.WatchList[index]) {
                        tmpscene.initVars(watch)
                        //                        tmpscene?.refreshWatch()
                    }

                }

            }
        }

    }
    
    func UpdateAllWatch(_ noti :Notification) -> Void {
        print("setting is changed!")
        for i in 0..<self.WatchList.count {
            self.updateWatch(index: i)
        }
    }

    //    private var WatchNum: Int = 0
    private var WatchList: [String] = []

    func addWatch(watchData: String) -> Void {
        let watchNum = self.WatchList.count
        self.WatchList.append(watchData)
        UserDefaults.standard.setValue(watchData, forKey: "WatchData" + String(watchNum))
        UserDefaults.standard.setValue(self.WatchList.count, forKey: "WatchNum")
        self.tableView.insertRows(at: [IndexPath.init(row: watchNum, section: 0)], with: .automatic)
        self.saveWatchToFile()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchSettingsViewControl {
            if (sender as? UIButton) != nil {
                nv.editRowIndex = -1
            } else {
                if let cell = sender as? UITableViewCell {
                    if let index = self.tableView.indexPath(for: cell) {
                        nv.editRowIndex = index.row
                        nv.setEditWatch(data: self.WatchList[index.row])
                    }

                }
            }
        }
    }

    @IBAction func unwindToManager(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? WatchSettingsViewControl {
            if nv.editRowIndex == -1 {
                let jsonData = nv.watch.toJSON()
                self.addWatch(watchData: jsonData)
            } else {
                let jsonData = nv.watch.toJSON()
                self.WatchList[nv.editRowIndex] = jsonData
                self.saveWatchToFile()
                self.updateWatch(index: nv.editRowIndex)
            }
        }
    }

    override func viewDidLoad() {
        IWatchSessionUtil.SessionManager.delegate = self
        IWatchSessionUtil.SessionManager.StartSession()
        self.needSyncWithWatch = true
        self.loadWatchFromFiles()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("WatchSettingsChanged"), object: nil, queue: nil, using: UpdateAllWatch)
    }

    func loadWatchFromFiles() {
        let watchNum = UserDefaults.standard.integer(forKey: "WatchNum")
        //        let watchNum = 0
        print("watch Num is ", watchNum)
        self.WatchList.removeAll()
        if (watchNum > 0) {
            for i in 0...watchNum - 1 {
                if let str = UserDefaults.standard.string(forKey: "WatchData" + String(i)) {
                    if (str != "") {
                        self.WatchList.append(str)
                    }
                }
            }
        }
    }

    func saveWatchToFile() {
        UserDefaults.standard.set(self.WatchList.count, forKey: "WatchNum")
        if (self.WatchList.count > 0) {
            for i in 0...WatchList.count - 1 {
                UserDefaults.standard.set(WatchList[i], forKey: "WatchData" + String(i))
            }
        }

        self.SyncWithWatch()
    }

    func deleteWatch(index: Int) {
        if (index < 0 || index >= self.WatchList.count) {
            return
        }

        self.WatchList.remove(at: index)
        self.saveWatchToFile()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.WatchList.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "watchitemcell") {
                if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                    let tmpscene: WatchScene = WatchScene.init(fileNamed: "FaceScene")!
                    if let watch = WatchInfo.fromJSON(data: self.WatchList[indexPath.row]) {
                        tmpscene.initVars(watch)
                    }
                    //                    tmpscene.initVars(self.watch)
                    tmpscene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
                    tmpscene.camera?.yScale = 1.8 / (184.0 / skview.bounds.height)

                    skview.presentScene(tmpscene)
                }

                return cell
            }
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.deleteWatch(index: indexPath.row)
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    @IBOutlet weak var AddButton: UIBarButtonItem!

    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBAction func EditButtonClick(_ sender: Any) {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
            self.EditButton.title = NSLocalizedString("Edit", comment: "")
            self.AddButton.isEnabled = true
        } else {
            self.tableView.setEditing(true, animated: true)
            self.EditButton.title = NSLocalizedString("Done", comment: "")
            self.AddButton.isEnabled = false
        }
    }

    private var watchIsConneted: Bool = false
    private var needSyncWithWatch: Bool = false

}

extension WatchManagerViewControl: WatchSessionDelegate {
    func onWatchMessage(message: [String: Any]) {

    }

    func onWatchReplay(dict: Dictionary<String, Any>) {
        for (_, value) in dict {
            self.showMessage(msg: value as! String)
        }
    }

    func onWatchError(error: Error) {
        self.showMessage(msg: error.localizedDescription)
    }


    func showMessage(msg: String) -> Void {
        DispatchQueue.main.async {
            self.navigationController?.view.makeToast(msg)
        }
    }

    func SyncWithWatch() -> Void {
        if (!self.watchIsConneted) {
            self.showMessage(msg: "Please Connect Watch First!")
            self.needSyncWithWatch = true
            return
        }

        //        let dict : Dictionary<String,Any> = Dictionary.init()
        //        dict.

        var dict: [String: Any] = [:]
        dict["WatchNum"] = self.WatchList.count
        for i in 0..<self.WatchList.count {
            dict["WatchData" + String(i)] = self.WatchList[i]
        }
        dict["WeekStyle"] = WatchSettings.WeekStyle
        dict["WeatherIconSize"] = WatchSettings.WeatherIconSize
        dict["DrawColorAQI"] = WatchSettings.WeatherDrawColorAQI
        dict["WeatherLocation"] = WatchSettings.WeatherLocation

        IWatchSessionUtil.SessionManager.SendMessageToWatch(msgDict: dict)



        //        IWatchSessionUtil.SessionManager.SendMessageToWatch(key: "WatchNum", value: self.WatchList.count)
        //        for i in 0..<self.WatchList.count {
        //            IWatchSessionUtil.SessionManager.SendMessageToWatch(key: "WatchData"+String(i), value: self.WatchList[i])
        //        }

        //        IWatchSessionUtil.SessionManager.SendMessageToWatch(key: "WeekStyle", value: WatchSettings.WeekStyle)
        //        IWatchSessionUtil.SessionManager.SendMessageToWatch(key: "WeatherIconSize", value: WatchSettings.WeatherIconSize)
        //        IWatchSessionUtil.SessionManager.SendMessageToWatch(key: "DrawColorAQI", value: WatchSettings.WeatherDrawColorAQI)
        //        IWatchSessionUtil.SessionManager.SendMessageToWatch(key: "WeatherLocation", value: WatchSettings.WeatherLocation)
    }



    func onWatchConneted() {
        self.showMessage(msg: "Watch is Conneted")
        self.watchIsConneted = true
        if self.needSyncWithWatch {
            self.SyncWithWatch()
            self.needSyncWithWatch = false
        }

    }

    func OnWatchDisConneted() {
        self.watchIsConneted = false
        self.showMessage(msg: "Watch is DisConneted")
    }


}

