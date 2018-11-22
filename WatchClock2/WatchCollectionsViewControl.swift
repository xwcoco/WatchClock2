//
//  WatchCollectionsViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/22.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchCollectionsViewControl: UITableViewController,WatchCollectionCellDelegate {
    func WatchCollectionClick(_ row: Int) {
        let watch = self.watchCollections[row]
        NotificationCenter.default.post(name: Notification.Name("WatchCollectionAddWatch"), object: watch)
        self.tabBarController?.view.makeToast("表盘已放入我的手表列表中")
    }
    
    
    private var watchCollections : [WatchInfo] = []
    
    override func viewDidLoad() {
        
        var jstr = "{\"secondIndex\":1,\"LogoToCenter\":48.672897338867188,\"tick_majorColorHex\":\"#FFFFFFFF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":1,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":0,\"minuteIndex\":0,\"customFace_ColorRegion_Color1Hex\":\"#1178A6FF\",\"tick_minorColorHex\":\"#7F7F7FFF\",\"bottomText\":{\"fontSize\":31.428565979003906,\"enabled\":true,\"backImageIndex\":1,\"weatherTextStyle\":0,\"fontName\":\"HermesESPACE\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"customFace_back_colorHex\":\"#000000FE\",\"numbers_fontSize\":20,\"faceIndex\":1,\"numeralStyle\":2,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":3,\"customFace_showColorRegion\":false}"
        var watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)
        
        jstr = "{\"secondIndex\":1,\"LogoToCenter\":48.672897338867188,\"tick_majorColorHex\":\"#FFFFFFFF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":1,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":1,\"minuteIndex\":2,\"customFace_ColorRegion_Color1Hex\":\"#1178A6FF\",\"tick_minorColorHex\":\"#7F7F7FFF\",\"bottomText\":{\"fontSize\":26.750001907348633,\"enabled\":true,\"backImageIndex\":1,\"weatherTextStyle\":0,\"fontName\":\"Arial\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FF9700FF\"},\"customFace_back_colorHex\":\"#000000FE\",\"numbers_fontSize\":20,\"faceIndex\":2,\"numeralStyle\":2,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":3,\"customFace_showColorRegion\":false}"
        
        watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)
        
        jstr = "{\"secondIndex\":3,\"LogoToCenter\":48.672897338867188,\"tick_majorColorHex\":\"#FFFFFFFF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":0,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":5,\"minuteIndex\":4,\"customFace_ColorRegion_Color1Hex\":\"#1178A6FF\",\"tick_minorColorHex\":\"#7F7F7FFF\",\"bottomText\":{\"fontSize\":26.750001907348633,\"enabled\":false,\"backImageIndex\":1,\"weatherTextStyle\":0,\"fontName\":\"Arial\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FF9700FF\"},\"customFace_back_colorHex\":\"#000000FE\",\"numbers_fontSize\":20,\"faceIndex\":16,\"numeralStyle\":2,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":3,\"customFace_showColorRegion\":false}"
        watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)
        
        jstr = "{\"secondIndex\":3,\"LogoToCenter\":48.672897338867188,\"tick_majorColorHex\":\"#FFFFFFFF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":0,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":5,\"minuteIndex\":4,\"customFace_ColorRegion_Color1Hex\":\"#1178A6FF\",\"tick_minorColorHex\":\"#7F7F7FFF\",\"bottomText\":{\"fontSize\":26.750001907348633,\"enabled\":false,\"backImageIndex\":1,\"weatherTextStyle\":0,\"fontName\":\"Arial\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FF9700FF\"},\"customFace_back_colorHex\":\"#000000FE\",\"numbers_fontSize\":20,\"faceIndex\":11,\"numeralStyle\":2,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":3,\"customFace_showColorRegion\":false}"
        watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)
        
        jstr = "{\"secondIndex\":5,\"LogoToCenter\":47.198516845703125,\"tick_majorColorHex\":\"#FFFFFFFF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":6,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":7,\"minuteIndex\":6,\"customFace_ColorRegion_Color1Hex\":\"#1178A6FF\",\"tick_minorColorHex\":\"#7F7F7FFF\",\"bottomText\":{\"fontSize\":26.750001907348633,\"enabled\":false,\"backImageIndex\":1,\"weatherTextStyle\":0,\"fontName\":\"Arial\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FF9700FF\"},\"customFace_back_colorHex\":\"#000000FE\",\"numbers_fontSize\":20,\"faceIndex\":17,\"numeralStyle\":2,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":3,\"customFace_showColorRegion\":false}"
        watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)
        
        jstr = "{\"secondIndex\":0,\"LogoToCenter\":47.198516845703125,\"tick_majorColorHex\":\"#FF8300FF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":8,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":3,\"minuteIndex\":2,\"customFace_ColorRegion_Color1Hex\":\"#E3D5C0FE\",\"tick_minorColorHex\":\"#7F7F7FFF\",\"bottomText\":{\"fontSize\":26.750001907348633,\"enabled\":false,\"backImageIndex\":1,\"weatherTextStyle\":0,\"fontName\":\"Arial\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FF9700FF\"},\"customFace_back_colorHex\":\"#20323BFE\",\"numbers_fontSize\":25.281896591186523,\"faceIndex\":0,\"numeralStyle\":0,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":1,\"customFace_showColorRegion\":true}"
    
    
        watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)
        
        jstr = "{\"secondIndex\":0,\"LogoToCenter\":47.198516845703125,\"tick_majorColorHex\":\"#FF8300FF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":8,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":3,\"minuteIndex\":2,\"customFace_ColorRegion_Color1Hex\":\"#0E6FD3FE\",\"tick_minorColorHex\":\"#7F7F7FFF\",\"bottomText\":{\"fontSize\":22.857141494750977,\"enabled\":true,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"Arial\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":52.579036712646484,\"textColorHex\":\"#FFFFFFFF\"},\"customFace_back_colorHex\":\"#F51E4FFE\",\"numbers_fontSize\":25.281896591186523,\"faceIndex\":0,\"numeralStyle\":0,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":1,\"customFace_showColorRegion\":true}"
        
        watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)

//        let color = UIColor.init(white: 0.282, alpha: 1)
//        print(color.toHex())
//        let color2 = UIColor.init(red: 0.941, green: 0.408, blue: 0.231, alpha: 1)
//        print(color2.toHex())
//        let color3 = UIColor.init(red: 0.941, green: 0.708, blue: 0.531, alpha: 1)
//        print(color3.toHex())
        
//        #474747FF
//        #EF683AFF
//        #EFB487FF
        
        jstr = "{\"secondIndex\":0,\"LogoToCenter\":47.198516845703125,\"tick_majorColorHex\":\"#EFB487FF\",\"rightText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"LogoIndex\":1,\"numbers_colorHex\":\"#FFFFFFFF\",\"hourIndex\":3,\"minuteIndex\":2,\"customFace_ColorRegion_Color1Hex\":\"#EF683AFF\",\"tick_minorColorHex\":\"#EFB487FF\",\"bottomText\":{\"fontSize\":22.857141494750977,\"enabled\":true,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"Arial\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":52.579036712646484,\"textColorHex\":\"#FFFFFFFF\"},\"customFace_back_colorHex\":\"#474747FF\",\"numbers_fontSize\":25.281896591186523,\"faceIndex\":1,\"numeralStyle\":2,\"leftText\":{\"fontSize\":25,\"enabled\":false,\"backImageIndex\":3,\"weatherTextStyle\":0,\"fontName\":\"\",\"showWeatchIcon\":false,\"textContentIndex\":0,\"distToCenter\":56,\"textColorHex\":\"#FFFFFFFF\"},\"faceStyle\":1,\"numbers_fontName\":\"\",\"tickmarkStyle\":0,\"customFace_showColorRegion\":true}"
        watch = WatchInfo.fromJSON(data: jstr)
        watchCollections.append(watch!)

        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchCollections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "watchcollectionitem")
        cell?.tag = indexPath.row
        (cell as? WatchCollectionCell)!.delegate = self
        
        if let skview: SKView = cell!.contentView.subviews[0] as? SKView {
            let tmpscene: WatchScene = WatchScene.init(fileNamed: "FaceScene")!
            tmpscene.initVars(self.watchCollections[indexPath.row])
            //                    tmpscene.initVars(self.watch)
            tmpscene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
            tmpscene.camera?.yScale = 1.8 / (184.0 / skview.bounds.height)
            
            skview.presentScene(tmpscene)
        }

        
        return cell!
    }
}


protocol WatchCollectionCellDelegate {
    func WatchCollectionClick(_ row : Int) -> Void
}

class WatchCollectionCell : UITableViewCell {
    
    var delegate : WatchCollectionCellDelegate?
    @IBAction func addButtonClick(_ sender: Any) {
        self.delegate?.WatchCollectionClick(self.tag)
    }
}
