//
//  ModelLocation.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/7/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import Foundation
struct ModelLocation {
    var address = ""
    var name = ""
    var lat = ""
    var lng = ""
    var urlImage = ""
    init(name:String, address: String, lat: Float, lng: Float, url: String){
        self.name = name
        self.address = address
        self.urlImage = url
        self.lat = String(lat)
        self.lng = String(lng)
    }
}
