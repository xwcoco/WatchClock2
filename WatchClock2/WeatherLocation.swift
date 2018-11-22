//
//  WeatherLocation.swift
//  watchClock
//
//  Created by xwcoco@msn.com on 2018/11/15.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import UIKit


struct WeatherXMLItem {
    var mode : Int = 0
    var quName: String
    var pyName: String
    var cityname: String
    var location: String

    public init() {
        quName = ""
        pyName = ""
        location = ""
        cityname = ""
    }
}

protocol WeatherLocationDelegate {
    func onFinishedGetData(data: [WeatherXMLItem]) -> Void
}

class WeatherLocation {

    public var XMLMode: Int = 0

    public func loadRootXML() {
        let url = "http://flash.weather.com.cn/wmaps/xml/china.xml"
        self.XMLMode = 0
        self.loadURL(urlStr: url)
    }

    public func loadNextXML(_ pyname: String) {
        self.XMLMode = 1
        let url = "http://flash.weather.com.cn/wmaps/xml/" + pyname + ".xml"
        self.loadURL(urlStr: url)
    }

    private func loadURL(urlStr: String) {
        let url = URL(string: urlStr)!
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
                self.loadData(data)
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

    public var delegate: WeatherLocationDelegate?

    private func loadData(_ data: Data) {
        let wd = WeatherXMLDecoder.init(xml: data,xmlmode: self.XMLMode)
        delegate?.onFinishedGetData(data: wd.XmlData)

    }
}

class WeatherXMLDecoder: NSObject, XMLParserDelegate {
    
    var mode : Int = 0
    required init(xml: Data,xmlmode : Int) {
        super.init()
        self.mode = xmlmode
        let parser = XMLParser.init(data: xml)
        parser.shouldProcessNamespaces = false
        parser.delegate = self
        parser.parse()
    }

    public var XmlData: [WeatherXMLItem] = []

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if (elementName.lowercased() == "city") {
            var item = WeatherXMLItem()
            item.mode = self.mode
            if let quname = attributeDict["quName"] {
                item.quName = quname
            }
            if let pyname = attributeDict["pyName"] {
                item.pyName = pyname
            }
            if let cityname = attributeDict["cityname"] {
                item.cityname = cityname
            }
            if let url = attributeDict["url"] {
                item.location = url
            }
            self.XmlData.append(item)
        }
//        print(elementName)
//        print(qName)
//        print(attributeDict)
    }

}
