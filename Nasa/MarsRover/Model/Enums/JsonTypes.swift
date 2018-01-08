//
//  JsonTypes.swift
//  Nasa
//
//  Created by karthick on 1/7/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation

enum JsonTypes: String {
    case getPhotos
    case getPhotosMissingImageSrc
    
    var description: String {
        switch self {
        case .getPhotos:
            return "GetPhotos"
        case .getPhotosMissingImageSrc:
            return "GetPhotosMissingImageSrc"
        }
    }
}
