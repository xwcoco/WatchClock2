//
//  WeatherLocationViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/22.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WeatherLocationViewControl: UITableViewController, WeatherLocationDelegate {
    func onFinishedGetData(data: [WeatherXMLItem]) {
        self.xml = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public var Location : String = ""
    public var CityName : String = ""
    
    private var xml: [WeatherXMLItem] = []
    
    private var weather: WeatherLocation = WeatherLocation()
    
    override func viewDidLoad() {
        self.weather.delegate = self
        self.weather.loadRootXML()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(self.xml.count)
        return self.xml.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        let item = self.xml[indexPath.row]
        if (item.mode == 0) {
            cell.textLabel?.text = item.quName
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = item.cityname
            if (item.pyName != "") {
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.xml[indexPath.row]
        if (item.mode != 0 && item.pyName == "" && item.location != "") {
            self.CityName = item.cityname
            self.Location = item.location
            self.performSegue(withIdentifier: "unwindToSetup", sender: self)
        }
        self.weather.loadNextXML(item.pyName)
    }
}

