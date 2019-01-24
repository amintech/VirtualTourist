//
//  LocationsInfo.swift
//  VirtualTourist
//
//  Created by  AminSaleh on 15/05/1440 AH.
//  Copyright © 1440 AminTech. All rights reserved.
//

import Foundation


class LocationsInfo {
    
    static var location = [LocationsInfo]()
    
    struct locatios: Codable {
        let imageURL: String?
    }
    
}
