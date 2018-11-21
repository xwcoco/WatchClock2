//
//  Weather.swift
//  watchClock
//
//  Created by xwcoco@msn.com on 2018/11/14.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import UIKit

protocol CnWeatherProtocol {
    func showWeather(_ data: CnWeatherData)
}

class CnWeather {

    var delegate: CnWeatherProtocol?
    var timer: Timer? = nil
    public var location: String = ""


    func beginTimer() {
        let tmpStr = WatchSettings.WeatherLocation
        if (tmpStr == self.location && self.weatherData != nil)  {
            self.delegate?.showWeather(self.weatherData!)
            return
        }
        
        
        timer = Timer.scheduledTimer(timeInterval: 1800,
                                     target: self,
                                     selector: #selector(getWeatherInfo),
                                     userInfo: nil,
                                     repeats: true)
        self.getWeatherInfo()

    }

    @objc private func getWeatherInfo() {
        self.location = WatchSettings.WeatherLocation
        if (self.location == "") {
            return
        }
        let url = URL(string: "http://wthrcdn.etouch.cn/WeatherApi?citykey=" + location)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.handleClientError(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response)
                    return
            }

            if let mimeType = httpResponse.mimeType, mimeType == "text/xml",
                let data = data,
                let _ = String(data: data, encoding: .utf8) {
                self.setWeatherData(data)
            }
        }
        task.resume()
    }

    func handleClientError(_ error: Error) {
        print(error)
    }

    func handleServerError(_ response: URLResponse?) -> Void {
        print(response ?? "response error")
    }

    private var weatherData : CnWeatherData?
    func setWeatherData(_ data: Data) {
//        print("get weather data")
        let wd = CnWeatherData.init(xml: data)
        print("weather update")
        self.weatherData = wd
//        print(wd)
        self.delegate?.showWeather(wd)


    }

}


struct weather {
    var type, fengxiang, fengli: String
    init() {
        type = ""
        fengxiang = ""
        fengli = ""
    }
}
struct forecast {
    var date, high, low: String
    var day, night: weather

    init() {
        date = ""
        high = ""
        low = ""
        day = weather.init()
        night = weather.init()
    }

}

class CnWeatherData: NSObject, XMLParserDelegate {
    var DataOK: Bool = false
    required init(xml: Data) {
        super.init()
        let parser = XMLParser.init(data: xml)
        parser.shouldProcessNamespaces = false
        parser.delegate = self
        self.DataOK = parser.parse()

    }


    private var currentNode: String = ""

    open var City: String = ""
    open var UpdateTime: String = ""
    open var Wendu: String = ""
    open var fengli: String = ""
    open var shidu: String = ""
    open var fengxiang: String = ""

    open var dayType: String = ""
    open var nightType: String = ""
    open var type: String = ""
    open var high: String = ""
    open var low: String = ""

    open var aqi: String = ""
    open var pm25: String = ""
    open var suggest: String = ""
    open var quality: String = ""
    open var pm10: String = ""

    private var forecastList: [forecast] = []
//    private var day : weather = weather.init()
//    private var night : weather = weather.init()
    private var curForecast: forecast = forecast.init()

    private var beginWeather: Bool = false
    private var beginWeatherDay: Bool = false
    private var beginWeatherNight: Bool = false

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if (elementName == "weather") {
            beginWeather = true
            self.curForecast = forecast.init()
        } else if (beginWeather) {
            switch elementName.lowercased() {
            case "day":
                self.beginWeatherDay = true
                break
            case "night":
                self.beginWeatherNight = true
                //                self.beginWeatherDay = false
                break
            default:
                break
            }

        }



//        print("begin : ",elementName,namespaceURI,qName)

        currentNode = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        print(string)
        switch currentNode.lowercased() {
        case "city":
            self.City = string
            break
        case "updatetime":
            self.UpdateTime = string
            break
        case "wendu":
            self.Wendu = string
            break
        case "fengli":
            self.fengli = string
            break
        case "shidu":
            self.shidu = string
            break
        case "fengxiang":
            self.fengxiang = string
            break
        case "aqi":
            self.aqi = string
            break
        case "pm25":
            self.pm25 = string
            break
        case "suggest":
            self.suggest = string
            break
        case "quality":
            self.quality = string
            break
        case "pm10":
            self.pm10 = string
        default:
            break
        }

        if (self.beginWeather) {
            switch (self.currentNode.lowercased()) {
            case "date":
                curForecast.date = string
                break
            case "high":
                curForecast.high = string
                break
            case "low":
                curForecast.low = string
                break
            case "type":
                if (beginWeatherDay) {
                    curForecast.day.type = string
                } else if (beginWeatherNight) {
                    curForecast.night.type = string
                }
                break
            case "fengxiang":
                if (beginWeatherDay) {
                    curForecast.day.fengxiang = string
                } else if (beginWeatherNight) {
                    curForecast.night.fengxiang = string
                }
                break
            case "fengli":
                if (beginWeatherDay) {
                    curForecast.day.fengli = string
                } else if (beginWeatherNight) {
                    curForecast.night.fengli = string
                }
                break

            default:
                break
            }

        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("end ", elementName)

        if (elementName == "weather") {
            self.beginWeather = false
        }

        if (self.beginWeather) {
            if (elementName == "day") {
                self.beginWeatherDay = false
            }
            if (elementName == "night") {
                self.beginWeatherNight = false
                self.forecastList.append(self.curForecast)
            }
        }

    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        if (self.forecastList.count > 0) {
            let date = Date()
            let calendar = NSCalendar.current
            let hour = calendar.component(.hour, from: date)
            
            let data = self.forecastList[0]
            if (hour >= 6 && hour <= 18) {
                self.type = data.day.type
            } else {
                self.type = data.night.type
            }
            self.high = data.high
            self.low = data.low
            self.dayType = data.day.type
            self.nightType = data.night.type
        }
        

    }
    
    public func getWeatherCode() -> String {
        var code = "01"
        switch self.type {
        case "晴":
            code = "01"
        case "多云":
            code = "02"
        case "阴":
            code = "03"
        case "阵雨":
            code = "04"
        case "雷阵雨":
            code = "05"
        case "雷阵雨伴有冰雹":
            code = "06"
        case "雨夹雪":
            code = "07"
        case "小雨":
            code = "08"
        case "中雨":
            code = "09"
        case "大雨":
            code = "13"
        case "暴雨":
            code = "14"
            
        case "大暴雨":
            code = "15"
        case "特大暴雨":
            code = "16"
        case "阵雪":
            code = "17"
        case "小雪":
            code = "18"
        case "中雪":
            code = "19"
        case "大雪":
            code = "20"
        case "暴雪":
            code = "21"
        case "雾":
            code = "25"
        case "冻雨":
            code = "26"
        case "沙尘暴":
            code = "27"
            
        case "小到中雨":
            code = "28"
        case "中到大雨":
            code = "29"
        case "大到暴雨":
            code = "30"
        case "暴雨到大暴雨":
            code = "31"
        case "大暴雨到特大暴雨":
            code = "32"
            
        case "小到中雪":
            code = "33"
        case "中到大雪":
            code = "37"
        case "大到暴雪":
            code = "38"
        case "浮尘":
            code = "39"
        case "扬沙":
            code = "40"
        case "强沙尘暴":
            code = "41"
        case "雨":
            code = "42"
        case "雪":
            code = "43"
        case "霾":
            code = "44"
        default:
            code = "01"
        }
        return code

    }


}
