//
//  PlaceModel.swift
//  FourSquareClone
//
//  Created by Ebuzer Şimşek on 4.05.2023.
//

import Foundation
import UIKit

class PlaceModel {
    static let sharedInstanse = PlaceModel()
    var placeName = ""
    var placeType = ""
    var placeComment = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    
    
    
    private init(){}
}
