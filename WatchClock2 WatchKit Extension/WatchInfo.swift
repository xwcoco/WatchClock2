//
//  WatchInfo.swift
//  watchClock
//
//  Created by xwcoco@msn.com on 2018/11/9.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit



enum WatchTextContent : Int,Codable {
    case WatchTextDate,WatchTextWeekDay,WatchTextWeather
}

enum WeatherTextStyle : Int,Codable {
    case WeatherTextTemp,WeatherTextType,WeatherTextAQI,WeatherTextPM25,WeatherTextPM10
}


class WatchText : Codable {
    
    public var enabled: Bool = true
    public var backImageIndex: Int = 3
    public var textContentIndex: WatchTextContent = .WatchTextDate
    
    private var textColorHex : String = UIColor.white.toHex()
    
    public var textColor: UIColor {
        get {
            return UIColor.init(hexString: textColorHex) ?? UIColor.white
        }
        set {
            textColorHex = newValue.toHex()
        }
    }
    public var distToCenter: CGFloat = 56

    public var fontName: String = ""
    public var fontSize: CGFloat = 25
    
    public var showWeatchIcon : Bool = false
    public var weatherTextStyle : WeatherTextStyle = .WeatherTextTemp
    
    public var weatherData : CnWeatherData? = WatchSettings.WeatherData
    
    private var backupText : String = ""
    
    public func needUpdate() -> Bool {
        if (!self.enabled) {
            return false
        }
        
        let newText = self.getText()
        if (newText != self.backupText) {
            return true
        }
        
        return false
    }
    
    
    public init() {
        
    }

    enum CodingKeys: String, CodingKey {
        case enabled
        case backImageIndex
        case textContentIndex
        case textColorHex
        case distToCenter
        case fontName
        case fontSize
        case showWeatchIcon
        case weatherTextStyle
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(enabled, forKey: .enabled)
//        try container.encode(backImageIndex, forKey: .backImageIndex)
//        try container.encode(textContentIndex.rawValue, forKey: .textContentIndex)
//        try container.encode(MyColor.UIColorToMyColor(textColor), forKey: .textColor)
//        try container.encode(distToCenter, forKey: .distToCenter)
//        try container.encode(fontName, forKey: .fontName)
//        try container.encode(fontSize, forKey: .fontSize)
//        try container.encode(showWeatchIcon, forKey: .showWeatchIcon)
//        try container.encode(weatherTextStyle.rawValue, forKey: .weatherTextStyle)
//    }


    private func getText() -> String {
        let calendar = NSCalendar.current
        let currentDate = Date()
        switch textContentIndex {
        case .WatchTextDate:
            let day: Int = calendar.component(.day, from: currentDate)
            return String(day)

        case .WatchTextWeekDay:
            let weekday = calendar.component(.weekday, from: currentDate)

            if (WatchSettings.WeekStyle == 0) {
                return WatchSettings.WeekStyle1[weekday - 1]
            }
            if (WatchSettings.WeekStyle == 1) {
                return WatchSettings.WeekStyle2[weekday - 1]
            }
            return WatchSettings.WeekStyle3[weekday - 1]
        default:
            if (self.weatherData != nil) {
                switch self.weatherTextStyle {
                case .WeatherTextTemp:
                    return self.weatherData!.Wendu
                case .WeatherTextType:
                    return self.weatherData!.type
                case .WeatherTextAQI:
                    return self.weatherData!.aqi
                case .WeatherTextPM25:
                    return self.weatherData!.pm25
                default:
                    return self.weatherData!.pm10
                    
                }
            }
            return ""
        }
    }
    
    func getAQIColor(_ aqi : Float) -> UIColor {
        if (aqi < 50) {
            return UIColor.green
        }
        if (aqi < 100) {
            return UIColor.yellow
        }
        if (aqi < 200) {
            return UIColor.orange
        }
        return UIColor.red
        
    }

    public func toImage() -> UIImage? {
        if (!self.enabled) {
            return UIImage.init(named: "none")
        }

        var img: UIImage?

        var size: CGSize?

        if (backImageIndex > 0) {
            img = UIImage.init(named: WatchSettings.GInfoBackgroud[backImageIndex])
            size = img?.size ?? nil
        }
        
        var weatherImg : UIImage?
        
        if (self.showWeatchIcon && self.textContentIndex == .WatchTextWeather && self.weatherData != nil) {
            let weatherIconName = "white_" + weatherData!.getWeatherCode()
            weatherImg = UIImage.init(named: weatherIconName)
        }
        
        self.backupText = self.getText()
        let text = NSString(string: backupText)

        var font: UIFont

        if (self.fontName == "") {
            font = UIFont.systemFont(ofSize: self.fontSize)
        } else {
            font = UIFont.init(name: self.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }

        let text_style = NSMutableParagraphStyle()
        text_style.alignment = NSTextAlignment.center
        
        var tmpTextColor = textColor
        
        if (self.textContentIndex == .WatchTextWeather && (weatherData != nil) && WatchSettings.WeatherDrawColorAQI) {
            switch self.weatherTextStyle {
            case .WeatherTextAQI:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.aqi)?.floatValue ?? 0)
                break
            case .WeatherTextPM25:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.pm25)?.floatValue ?? 0)
                break
            case .WeatherTextPM10:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.pm10)?.floatValue ?? 0)
                break
            default:
                break
            }
        }
        
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: text_style, NSAttributedString.Key.foregroundColor: tmpTextColor]

        let rect = text.boundingRect(with: CGSize(width: 500, height: 500), options: [], attributes: attributes, context: nil)
        if (size == nil) {
            size = CGSize(width: rect.width, height: rect.height)
            
            if (size?.width == 0 || size?.height == 0) {
                size = CGSize(width: 10, height: 10)
            }
            
            if (weatherImg != nil) {
                size!.width = size!.width + WatchSettings.WeatherIconSize
                
                if (size!.height < WatchSettings.WeatherIconSize) {
                    size!.height = WatchSettings.WeatherIconSize
                }
            }
        } else if (weatherImg != nil) {
            if (size!.width < WatchSettings.WeatherIconSize + rect.width) {
                size!.width = WatchSettings.WeatherIconSize + rect.width
            }
            if (size!.height < max(WatchSettings.WeatherIconSize,rect.height)) {
                size!.height = max(WatchSettings.WeatherIconSize,rect.height)
            }
        }

        UIGraphicsBeginImageContext(size!)

        let context = UIGraphicsGetCurrentContext()

        if (backImageIndex > 0) {
            img?.draw(in: CGRect(origin: CGPoint.zero, size: size!))
        } else {
            context?.setFillColor(UIColor.clear.cgColor)
            context?.fill(CGRect.init(x: 0, y: 0, width: size!.width, height: size!.height))
        }
        
        //vertically center (depending on font)
        let text_h = font.lineHeight
        let text_y = (size!.height - text_h) / 2
        var text_rect = CGRect(x: 0, y: text_y, width: size!.width, height: text_h)

        if (weatherImg != nil) {
            let tmpy = (size!.height - WatchSettings.WeatherIconSize) / 2
            let tmpx = (size!.width - WatchSettings.WeatherIconSize - rect.width) / 2
            let weatherRect = CGRect(x: tmpx, y: tmpy, width: WatchSettings.WeatherIconSize, height: WatchSettings.WeatherIconSize)
            weatherImg?.draw(in: weatherRect)
            text_rect = CGRect(x: tmpx + WatchSettings.WeatherIconSize, y: text_y, width: size!.width - WatchSettings.WeatherIconSize - 2 * tmpx, height: text_h)
        }

        text.draw(in: text_rect.integral, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

protocol WatchInfoUpdate {
    func UpdateWatchInfo(refresh : Bool) -> Void
}

class WatchInfo: Codable {
    public var faceIndex: Int = 1

    public var LogoIndex: Int = 8
    public var LogoToCenter: CGFloat = 32

    public var hourIndex: Int = 0
    public var minuteIndex: Int = 0
    public var secondIndex: Int = 1

    public var bottomText: WatchText = WatchText()
    public var leftText: WatchText = WatchText()
    public var rightText: WatchText = WatchText()
    
    public var delegate : WatchInfoUpdate?
    


    public var TotalNum: Int = 0
    public var index: Int = 0
    
    
    private var timer : Timer?

    public init() {
        leftText.enabled = false
        rightText.enabled = false
    
        self.initAfterFromJSON()
    }
    
    private func initAfterFromJSON() {
        NotificationCenter.default.addObserver(forName: Notification.Name("WeatherDataUpdate"), object: nil, queue: nil, using: setWeatherData)
        timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(CheckUpdate),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc public func setWeatherData(notification:Notification) {
        self.bottomText.weatherData = WatchSettings.WeatherData
        self.leftText.weatherData = WatchSettings.WeatherData
        self.rightText.weatherData = WatchSettings.WeatherData
        
        self.delegate?.UpdateWatchInfo(refresh: false)
    }
    
    @objc func CheckUpdate() {
        if (self.bottomText.needUpdate() || self.rightText.needUpdate() || self.leftText.needUpdate()) {
            self.delegate?.UpdateWatchInfo(refresh: false)
        }
    }
    
//    public var useCustomFace: Bool = false
    
//    public var customFace_draw_back: Bool = false
    
    private var customFace_back_colorHex : String = UIColor.clear.toHex()
    
    public var customFace_back_color: UIColor {
        get {
            return UIColor.init(hexString: customFace_back_colorHex) ?? UIColor.black
        }
        
        set {
            customFace_back_colorHex = newValue.toHex()
        }
    }
    
    public var customFace_showColorRegion: Bool = true
    
    private var customFace_ColorRegion_Color1Hex : String = UIColor.init(red: 0.067, green: 0.471, blue: 0.651, alpha: 1.000).toHex()
    
    public var customFace_ColorRegion_Color1: UIColor {
        get {
            return UIColor.init(hexString: self.customFace_ColorRegion_Color1Hex) ?? UIColor.black
        }
        set {
            self.customFace_ColorRegion_Color1Hex = newValue.toHex()
        }
    }
    
//    private var customFace_ColorRegion_Color2Hex : String = UIColor.init(red: 0.118, green: 0.188, blue: 0.239, alpha: 1.000).toHex()
//    public var customFace_ColorRegion_Color2: UIColor {
//        get {
//            return UIColor.init(hexString: self.customFace_ColorRegion_Color2Hex) ?? UIColor.black
//        }
//        set {
//            self.customFace_ColorRegion_Color2Hex = newValue.toHex()
//        }
//    }
    
//    private var customFace_ColorRegion_AlternateTextColorHex : String = UIColor.init(white: 1, alpha: 0.8).toHex()
//    public var customFace_ColorRegion_AlternateTextColor: UIColor {
//        get {
//            return UIColor.init(hexString: self.customFace_ColorRegion_AlternateTextColorHex) ?? UIColor.white
//        }
//        set {
//            self.customFace_ColorRegion_AlternateTextColorHex = newValue.toHex()
//        }
//    }
    
//    private var customFace_ColorRegion_AlternateMajorColorHex : String = UIColor.init(red: 1.000, green: 0.506, blue: 0.000, alpha: 1.000).toHex()
//    public var customFace_ColorRegion_AlternateMajorColor: UIColor  {
//        get {
//            return UIColor.init(hexString: customFace_ColorRegion_AlternateMajorColorHex) ?? UIColor.white
//        }
//        set {
//            customFace_ColorRegion_AlternateMajorColorHex = newValue.toHex()
//        }
//    }
    
//    private var customFace_ColorRegion_AlternateMinorColorHex : String = UIColor.black.withAlphaComponent(0.5).toHex()
//    public var customFace_ColorRegion_AlternateMinorColor: UIColor {
//        get {
//            return UIColor.init(hexString: customFace_ColorRegion_AlternateMinorColorHex) ?? UIColor.black
//        }
//        set {
//            customFace_ColorRegion_AlternateMinorColorHex = newValue.toHex()
//        }
//    }
    
    public var numeralStyle: NumeralStyle = NumeralStyle.NumeralStyleAll
    public var tickmarkStyle: TickmarkStyle = .TickmarkStyleAll
    public var faceStyle: WatchFaceStyle = .WatchFaceStyleRectangle
    
    public var numbers_fontName: String = ""
    public var numbers_fontSize: CGFloat = 20
    
    private var numbers_colorHex : String = UIColor.white.toHex()
    public var numbers_color: UIColor {
        get {
            return UIColor.init(hexString: numbers_colorHex) ?? UIColor.white
        }
        set {
            numbers_colorHex = newValue.toHex()
        }
    }
    
    private var tick_majorColorHex : String = UIColor.white.toHex()
    public var tick_majorColor: UIColor {
        get {
            return UIColor.init(hexString: tick_majorColorHex) ?? UIColor.white
        }
        set {
            tick_majorColorHex = newValue.toHex()
        }
    }
    
    private var tick_minorColorHex : String = UIColor.gray.toHex()
    
    public var tick_minorColor: UIColor {
        get {
            return UIColor.init(hexString: tick_minorColorHex) ?? UIColor.gray
        }
        
        set {
            tick_minorColorHex = newValue.toHex()
        }
    }


    enum CodingKeys: String, CodingKey {
        case faceIndex
        case LogoIndex
        case LogoToCenter
        case hourIndex
        case minuteIndex
        case secondIndex
//        case useCustomFace
//        case customFace_draw_back
        case customFace_back_colorHex
        case customFace_showColorRegion
        case customFace_ColorRegion_Color1Hex
//        case customFace_ColorRegion_Color2Hex
//        case customFace_ColorRegion_AlternateTextColorHex
//        case customFace_ColorRegion_AlternateMajorColorHex
//        case customFace_ColorRegion_AlternateMinorColorHex
        case numeralStyle
        case tickmarkStyle
        case faceStyle
        case numbers_fontName
        case numbers_fontSize
        case numbers_colorHex
        case tick_majorColorHex
        case tick_minorColorHex
        case bottomText
        case leftText
        case rightText
    }
    

    public func toJSON() -> String {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        catch {
            print(error)
        }
        return ""

    }
    
    public static func fromJSON(data : String) -> WatchInfo? {
        let jsonDecoder = JSONDecoder()
        if let jsonData : Data = data.data(using: .utf8) {
            do {
                let watch = try jsonDecoder.decode(WatchInfo.self, from: jsonData)
                watch.initAfterFromJSON()
                return watch
            }
            catch {
                print(error)
            }
        }
        return nil
    }
    
    private var updateCounter : Int = 0
    public func beginUpdate() {
        self.updateCounter = self.updateCounter + 1
    }
    
    public func endUpdate() {
        self.updateCounter = self.updateCounter - 1
        if (self.updateCounter < 0) {
            self.updateCounter = 0
        }
        if (updateCounter == 0) {
            self.delegate?.UpdateWatchInfo(refresh: true)
        }
    }

}





