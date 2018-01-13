//
//  PhotosMock.swift
//  NasaTests
//
//  Created by karthick on 1/12/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
@testable import Nasa

class PhotosMock {
    static func getMockPhoto() -> Photos {
        let dic: NSDictionary = ["photos": [["id": 1.0, "sol": 10, "img_src": "https://www.google.com"], ["id": 1.0, "sol": 10, "img_src": "https://www.google.com"]]]
        return Photos.from(dic)!
    }
    
    static func getEmptyPhotoDetailsMock() -> Photos {
        let dic: NSDictionary = ["photos": []]
        return Photos.from(dic)!
    }
}
