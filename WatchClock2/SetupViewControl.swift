//
//  SetupViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/22.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class SetupViewControl: UITableViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            cell.accessoryType = .none
            if (indexPath.row == WatchSettings.WeekStyle) {
                cell.accessoryType = .checkmark
            }
        }
        if (indexPath.section == 1) {
            self.setLabelSliderCell(name: "Wather Icon Size", value: WatchSettings.WeatherIconSize, indexPath: indexPath)
        }
        if (indexPath.section == 2) {
            if (WatchSettings.WeatherCity == "") {
                cell.textLabel?.text = "(None)"
            } else {
                cell.textLabel?.text = WatchSettings.WeatherCity
            }
        }
        if (indexPath.section == 3) {
            if WatchSettings.WeatherDrawColorAQI {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            self.setNewCheckmark(section: 0, cellNum: 2, newIndex: indexPath.row)
            WatchSettings.WeekStyle = indexPath.row
        }
        if (indexPath.section == 3) {
            let cell = self.tableView.getCell(at: indexPath)
            if cell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell?.accessoryType = .none
                WatchSettings.WeatherDrawColorAQI = false
            } else {
                cell?.accessoryType = .checkmark
                WatchSettings.WeatherDrawColorAQI = true
            }
        }
    }
    
    @IBAction func IconSizeSliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            WatchSettings.WeatherIconSize = CGFloat(slider.value)
            self.setLabelSliderCell(name: "Wather Icon Size", value: WatchSettings.WeatherIconSize, indexPath: IndexPath.init(row: 0, section: 1), setSlider: false)
            
        }
        
    }
    
    @IBAction func unwindToSetup(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if let nv = sourceViewController as? WeatherLocationViewControl {
            WatchSettings.WeatherLocation = nv.Location
            WatchSettings.WeatherCity = nv.CityName
            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: 2))
            cell?.textLabel?.text = nv.CityName
        }
        // Use data from the view controller which initiated the unwind segue
    }

}
