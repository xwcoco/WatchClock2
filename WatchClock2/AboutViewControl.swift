//
//  AboutViewControl.swift
//  watchClock
//
//  Created by xwcoco@msn.com on 2018/11/15.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import UIKit

class AboutViewControl: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        //        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let boundVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        
        //        let
        versionLabel.text = "Version : " + boundVersion!
        
        let buildDate = Bundle.main.infoDictionary!["CFBundleBuildDate"] as? String
        infoLabel.text = "Build date : " + buildDate! + "\n" + "Code by xwcoco@msn.com\n\n" + "Thank you guys:  \n" + "JacobSyndeo\n"+"steventroughtonsmith \n" + "JosephShenton\n" + " wusaul \n" + "jin9000"
    }
}
