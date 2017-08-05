//
//  ModelAlamofire.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/6/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import Foundation
import UIKit
class ModelAlamofire: NSObject{
    var address = ""
    var name = ""
    var lat = ""
    var lng = ""
    var urlImage = ""
    init?(JSON: [String: Any]) {
        guard let name = JSON["name"] as? String else {return nil} // icon
        guard let icon = JSON["icon"] as? String else {return nil}
        guard let address = JSON["vicinity"] as? String else {return nil}
        guard let urlImage = JSON["icon"] as? String else {return nil}
        guard let arrayLocation = JSON["geometry"] as? [String: Any] else {return nil}
        guard let location = arrayLocation["location"] as? [String: Double] else {return nil}
        guard let lat = location["lat"] else {return nil}
        guard let lng = location["lng"] else{
            return nil}
        self.name = name
        self.address = address
        self.urlImage = urlImage
        self.lat = String(lat)
        self.lng = String(lng)
        self.urlImage = icon
    }
}
