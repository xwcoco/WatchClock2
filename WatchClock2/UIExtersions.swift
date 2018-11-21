//
//  UIExtersions.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/20.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    public func toHex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        guard r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1 else {
            return ""
        }
        return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
}

extension UIFont {
    func SmallCaps() -> UIFont {
        let settings = [UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType, UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseSmallCapsSelector]
        return UIFont.init(descriptor: UIFontDescriptor.init(fontAttributes: [UIFontDescriptor.AttributeName.featureSettings: settings, UIFontDescriptor.AttributeName.name: self.fontName]), size: self.pointSize)
    }
}

extension UIImage {
    public class func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 1, y: 1, width: size.width - 2, height: size.height - 2))
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public class func imageWithPureColor(color: UIColor, size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}


