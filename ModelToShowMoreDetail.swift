//
//  ModelToShowMoreDetail.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/3/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import UIKit

class ModelToShowMoreDetail: NSObject {
    var lat: String = ""
    var lng: String = ""
    var name: String = ""
    var vicinity: String = ""
    init(lat: String, lng: String, name: String, vicinity: String) {
        self.lat = "Lat: " + lat
        self.lng = "Lng: " + lng
        self.name = "Name: " + name
        self.vicinity = "Address: " + vicinity
    }
}
