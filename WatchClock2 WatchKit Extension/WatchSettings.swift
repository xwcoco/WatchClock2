//
//  WatchSettings.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/20.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WatchSettings: NSObject, CnWeatherProtocol {
    
    static var sharedInstance : WatchSettings = WatchSettings()
    
    static var GFaceNameList: [String] = ["empty",
                                          "Hermes_watch_face_original",
                                          "Hermes_watch_face_original_orange",
                                          "Hermes_watch_face_classic",
                                          "Hermes_watch_face_classic_orange",
                                          "Hermes_watch_face_roma",
                                          "Hermes_watch_face_roma_orange",
                                          "Hermes_watch_face_standard",
                                          "Hermes_watch_face_standard_orange",
                                          "Nike_watch_face_black",
                                          "Nike_watch_face_blue",
                                          "Nike_watch_face_green",
                                          "Nike_watch_face_greenblue",
                                          "Nike_watch_face_grey",
                                          "Nike_watch_face_night",
                                          "Nike_watch_face_pink",
                                          "Nike_watch_face_red",
                                          "Rolex_watch_face_black_gold",
                                          "Rolex_watch_face_black_silver",
                                          "Rolex_watch_face_black_white",
                                          "Rolex_watch_face_green",
                                          "Rolex_watch_face_luminous",
                                          "S4Numbers"]
    
    static var GHourImageList: [String] = ["Hermes_hours",
                                           "Hermes_hours_white",
                                           "HermesDoubleclour_H",
                                           "HermesDoubleclour_H_Orange",
                                           "HermesDoubleclour_H_Pink",
                                           "Nike_hours",
                                           "Nike_hours_red",
                                           "Rolex_hours_gold",
                                           "Rolex_hours_luminous",
                                           
                                           "Rolex_hours_write"]
    
    static var GMinuteImageList: [String] = ["Hermes_minutes",
                                             "Hermes_minutes_white",
                                             "HermesDoubleclour_M_Orange",
                                             "HermesDoubleclour_M_Pink",
                                             "Nike_minutes",
                                             "Nike_minutes_red",
                                             "Rolex_minutes_gold",
                                             "Rolex_minutes_luminous",
                                             "Rolex_minutes_write"]
    
    static var GMinutesAnchorFromBottoms: [CGFloat] = [16, 16, 18, 18, 17, 17, 17, 17, 17]
    
    static var GSecondImageList: [String] = ["empty",
                                             "Hermes_seconds",
                                             "Hermes_seconds_orange",
                                             "Nike_seconds",
                                             "Nike_seconds_orange",
                                             "Rolex_seconds_gold",
                                             "Rolex_seconds_luminous",
                                             "Rolex_seconds_write"]
    
    static var GSecondsAnchorFromBottoms: [CGFloat] = [0, 27, 27, 26, 26, 67, 67, 67]
    
    static var GLogoImageList: [String] = ["empty",                       "hermes_logo_white",
                                           "hermes_logo_2",
                                           "gucci_log",
                                           "constantin_logo",
                                           "Patek_Philippe_logo",
                                           "rolex_logo_gold",
                                           "apple_logo_color",
                                           "apple_logo_white"]
    
    static var GInfoBackgroud: [String] = ["empty",
                                           "info_back_1_52x46",
                                           "info_back_2_52x46",
                                           "info_back_3_36x32",
                                           "info_back_4_36x32"
    ]
    
    static func getImageName(list : [String],index : Int) -> String {
        if (index >= 0 && index < list.count) {
            return list[index]
        }
        if (list.count > 0) {
            return list[0]
        }
        return ""
        
    }
    
    private var cnWeather: CnWeather?
    
    var weatherData: CnWeatherData?
    
    private override init() {
        super.init()
        self.loadSettings()
    }
    
    static var WeekStyle1: [String] = ["日", "一", "二", "三", "四", "五", "六"]
    static var WeekStyle2: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    static var WeekStyle3: [String] = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
    
    
    private var _weekStyle: Int = 0
    

    static var WeekStyle: Int {
        get {
            return sharedInstance._weekStyle
        }
        set {
            sharedInstance._weekStyle = newValue
            UserDefaults.standard.set(newValue, forKey: "WeekStyle")
        }
    }

    private var _weatherIconSize: CGFloat = 20

    static var WeatherIconSize: CGFloat {
        get {
            return sharedInstance._weatherIconSize
        }

        set {
            sharedInstance._weatherIconSize = newValue
            UserDefaults.standard.set(newValue, forKey: "WeatherIconSize")
        }
    }

    private var _WeatherDrawColorAQI: Bool = true

    static var WeatherDrawColorAQI: Bool {
        get {
            return sharedInstance._WeatherDrawColorAQI
        }
        set {
            sharedInstance._WeatherDrawColorAQI = newValue
            UserDefaults.standard.set(newValue, forKey: "DrawColorAQI")
        }
    }

    private var _weather_city: String = ""
    static var WeatherCity: String {
        get {
            return sharedInstance._weather_city
        }
        set {
            sharedInstance._weather_city = newValue
            UserDefaults.standard.set(newValue, forKey: "WeatherCity")
        }
    }

    private var _weather_location: String = ""
    static var WeatherLocation: String {
        get {
            return sharedInstance._weather_location
        }

        set {
            sharedInstance._weather_location = newValue
            UserDefaults.standard.set(newValue, forKey: "WeatherLocation")
            sharedInstance.cnWeather?.beginTimer()
        }
    }


    private func loadSettings() {
        self._weekStyle = UserDefaults.standard.integer(forKey: "WeekStyle")
        self._WeatherDrawColorAQI = UserDefaults.standard.bool(forKey: "DrawColorAQI")
        self._weather_location = UserDefaults.standard.string(forKey: "WeatherLocation") ?? ""
        self._weather_city = UserDefaults.standard.string(forKey: "WeatherCity") ?? ""
        self._weatherIconSize = CGFloat(UserDefaults.standard.float(forKey: "WeatherIconSize"))
        if (self._weatherIconSize == 0) {
            self._weatherIconSize = 20
        }
    }

    static var WeatherData: CnWeatherData? {
        get {
            return sharedInstance.weatherData
        }
    }

    static func reloadSettings() {
        sharedInstance.loadSettings()
    }

    func showWeather(_ data: CnWeatherData) {
        self.weatherData = data
        NotificationCenter.default.post(name: Notification.Name("WeatherDataUpdate"), object: self)
        //        NotificationCenter.default.post(Notification.init(name: Notification.Name("WeatherDataUpdate")))
        //        self.currentWatch?.setWeatherData(data: data)
    }


    private func _loadWeatherData() {
        if (self.cnWeather == nil) {
            self.cnWeather = CnWeather()
            cnWeather?.delegate = self
            cnWeather?.beginTimer()
        }
    }

    static func LoadWeatherData() {
        sharedInstance._loadWeatherData()
    }

}

enum NumeralStyle: Int, Codable {
    case NumeralStyleAll, NumeralStyleCardinal, NumeralStyleNone
}

enum TickmarkStyle: Int, Codable {
    case TickmarkStyleAll, TickmarkStyleMajor, TickmarkStyleMinor, TickmarkStyleNone
}

enum WatchFaceStyle: Int, Codable {
    case WatchFaceStyleRound, WatchFaceStyleRectangle
}

