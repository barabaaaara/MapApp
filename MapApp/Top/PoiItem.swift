//
//  PoiItem.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/04/10.
//

import Foundation
import GoogleMapsUtils

class POIItem: NSObject, GMUClusterItem {

    var position: CLLocationCoordinate2D
    var storeName: String
    var smokingSpace: String
    var openHour: String
    var closeHour: String
    var tel: String
    var id: String

    init(position: CLLocationCoordinate2D,storeName: String,smokingSpace: String,openHour: String,closeHour: String,tel: String,id:String) {
        self.position = position
        self.storeName = storeName
        self.smokingSpace = smokingSpace
        self.openHour = openHour
        self.closeHour = closeHour
        self.tel = tel
        self.id = id
    }
}
