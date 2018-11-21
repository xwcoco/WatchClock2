//
//  ColorSelectViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/21.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class ColorSelectViewControl: UITableViewController, ColorTableViewCellTouchDelegate {
    var editColor: UIColor?
    var editIndexPath: IndexPath?
    var backSegueName: String = ""

    @IBOutlet weak var demoColorView: UIImageView!
    @IBOutlet weak var hueColor: UIImageView!

    @IBOutlet weak var alphaColorSlider: UISlider!
    @IBOutlet weak var blueColorSlider: UISlider!
    @IBOutlet weak var greenColorSlider: UISlider!
    @IBAction func SliderValueChanged(_ sender: Any) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.editColor?.getRed(&r, green: &g, blue: &b, alpha: &a)

        if let slider = sender as? UISlider {
            switch slider {
            case self.redColorSlider:
                r = CGFloat(slider.value)
                break
            case self.greenColorSlider:
                g = CGFloat(slider.value)
                break
            case self.blueColorSlider:
                b = CGFloat(slider.value)
                break
            case self.alphaColorSlider:
                a = CGFloat(slider.value)
                break
            default:
                break
            }
            
            self.editColor = UIColor.init(red: r, green: g, blue: b, alpha: a)
            self.showEditColor()
        }
    }
    @IBOutlet weak var redColorSlider: UISlider!
    override func viewDidLoad() {
        let size: CGSize = CGSize.init(width: self.hueColor!.bounds.width, height: self.hueColor!.bounds.height)
        self.hueColor.image = self.generateHUEImage(size)

        self.showEditColor()

        if let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: 0)) as? ColorTableViewCell {
            cell.hueColor = self.hueColor
            cell.delegate = self
        }

    }

    private func showEditColor() {
        let demoSize = CGSize.init(width: self.demoColorView.bounds.width, height: self.demoColorView.bounds.height)
        self.demoColorView.image = UIImage.imageWithColor(color: editColor!, size: demoSize)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.editColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.redColorSlider.value = Float(r)
        self.greenColorSlider.value = Float(g)
        self.blueColorSlider.value = Float(b)
        self.alphaColorSlider.value = Float(a)
        

    }

    open var cornerRadius: CGFloat = 10.0

    func generateHUEImage(_ size: CGSize) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()

        for y: Int in 0 ..< Int(size.height) {

            UIColor(hue: CGFloat(CGFloat(y) / size.height), saturation: 1.0, brightness: 1.0, alpha: 1.0).set()
            let temp = CGRect(x: 0, y: CGFloat(y), width: size.width, height: 1)
            UIRectFill(temp)
        }

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }


    internal func handleTouch(_ point: CGPoint) {
        if (point.y == -1) {
            return
        }

        let value = point.y / self.hueColor.bounds.height
        self.editColor = UIColor.init(hue: value, saturation: 1.0, brightness: 1.0, alpha: CGFloat(self.alphaColorSlider?.value ?? 1))
        self.showEditColor()
    }

    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: self.backSegueName, sender: self)
    }
    
}


protocol ColorTableViewCellTouchDelegate {
    func handleTouch(_ point: CGPoint) -> Void
}

class ColorTableViewCell: UITableViewCell {
    var e: UIEvent?
    var hueColor: UIImageView?
    var delegate: ColorTableViewCellTouchDelegate?
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if (e != nil && e == event) {
//            e = nil
//            return super.hitTest(point, with: event)
//
//        }
        if (event?.type == UIEvent.EventType.touches) {
            let touches = event?.touches(for: hueColor ?? self)
            let touch: UITouch? = touches?.first
            if (touch?.phase == UITouch.Phase.began || touch?.phase == UITouch.Phase.moved || touch?.phase == UITouch.Phase.ended) {
                let point: CGPoint = touch?.location(in: self.hueColor) ?? CGPoint.init(x: -1, y: -1)
                self.delegate?.handleTouch(point)
            }
        }
        return super.hitTest(point, with: event)
    }
}
