//
//  WatchSetViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/20.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WatchSettingsViewControl: UITableViewController {
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200
        }
        
        return UIScreen.main.bounds.height - 200
    }
    
}
