//
//  WatchSetViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/20.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchSettingsViewControl: UITableViewController {

    var watch: WatchInfo = WatchInfo()
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200
        }
        
        return UIScreen.main.bounds.height - 400
    }
    
    override func viewDidLoad() {
        self.setDemoWatch()
    }
    
    func setDemoWatch() -> Void {
        if let cell: UITableViewCell = self.tableView.getCell(at: IndexPath(row: 0, section: 0)) {
            if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                
                if (skview.scene == nil) {
                    let tmpscene: WatchScene = WatchScene.init(fileNamed: "FaceScene")!
                    
                    tmpscene.initVars(self.watch)
                    
                    tmpscene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
                    tmpscene.camera?.yScale = 1.8 / (184.0 / skview.bounds.height)
                    
                    skview.presentScene(tmpscene)
                } else {
                    let tmpscene = skview.scene as? WatchScene
                    tmpscene?.refreshWatch()
                }
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FaceStyleView") {
            if let nv = segue.destination as? UINavigationController {
                
                if let fs = nv.topViewController as? FaceStyleViewControl {
                    fs.watch = self.watch
                }
            }
        }
    }
    
    
}

extension UITableView {
    func getCell(at: IndexPath) -> UITableViewCell? {
        //当列表太多时，一行未显示，cellforRow 会返回 nil
        var cell = self.cellForRow(at: at)
        if (cell == nil) {
            cell = self.dataSource?.tableView(self, cellForRowAt: at)
        }
        return cell
    }
}
