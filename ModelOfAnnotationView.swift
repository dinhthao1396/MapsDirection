//
//  ModelOfAnnotationView.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/4/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import UIKit

class ModelOfAnnotationView: NSObject {
    var lat: Float
    var lng: Float
    var name: String = ""
    var vicinity: String = ""
    var url: String = ""
    init(latModel: Float, lngModel: Float, nameModel: String, vicinityModel: String, urlModel: String) {
        self.lat = latModel
        self.lng = lngModel
        self.name = "Name:" + nameModel
        self.vicinity = "Address:" + vicinityModel
        self.url = urlModel
    }
}
