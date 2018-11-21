//
//  FontSelectViewControl.swift
//  watchClock
//
//  Created by xwcoco@msn.com on 2018/11/12.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import UIKit

class FontSelectViewControl: UITableViewController {
    
    public var selectedFontName : String = ""
    
    private var fontNameList : [String] = []
    
    public var backToSegueName : String = ""
    
    public var editRowIndex : IndexPath?
    
    override func viewDidLoad() {
        fontNameList = UIFont.familyNames
        fontNameList.sort()
        
        if (selectedFontName != "") {
            if let index = fontNameList.firstIndex(of: selectedFontName) {
                self.tableView.scrollToRow(at: IndexPath.init(row: index, section: 0), at: .middle, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fontNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "fontitem")
        
        cell.backgroundColor = UIColor.black
        
        let name = self.fontNameList[indexPath.row]
        //        let name = UIFont.familyNames[indexPath.row]
        //        let fontName = UIFont.fontNames(forFamilyName: name)
        //        print(fontName)
        
        if (name == selectedFontName) {
            cell.accessoryType = .checkmark
        }
        
        cell.textLabel?.text = name
        cell.textLabel?.textColor = UIColor.white
        
        //        cell.textLabel?.font = UIFont.init(name: name, size: CGFloat(15))
        cell.detailTextLabel?.font = UIFont.init(name: name, size: CGFloat(12))
        cell.detailTextLabel?.text = "1234567890"
        cell.detailTextLabel?.textColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFontName = self.fontNameList[indexPath.row]
        //        self.selectedFontName = UIFont.familyNames[indexPath.row]
        self.performSegue(withIdentifier: self.backToSegueName, sender: self)
    }
}
