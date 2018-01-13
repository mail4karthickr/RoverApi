//
//  PhotosModelTests.swift
//  NasaTests
//
//  Created by karthick on 1/8/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import Moya
import RxBlocking
import RxSwift
import SwiftyJSON
import Moya_ModelMapper
@testable import Nasa

class PhotosModelTests: XCTestCase {
    func testPhotoDetailsMapper() {
        let photoDetails: NSDictionary = ["id": 12345, "sol": 3456789, "img_src": "https://www.google.com"]
        let photoDetailsModel = PhotoDetails.from(photoDetails)
        
        XCTAssertNotNil(photoDetailsModel)
        XCTAssertEqual(photoDetailsModel?.id, 12345)
        XCTAssertEqual(photoDetailsModel?.sol, 3456789)
        XCTAssertEqual(photoDetailsModel?.imageSrc, URL(string: "https://www.google.com"))
    }
    
    func testPhotosMapper() {
        let dic: NSDictionary = ["photos": [["id": 1.0, "sol": 10, "img_src": "https://www.google.com"], ["id": 1.0, "sol": 10, "img_src": "https://www.google.com"]]]
        let photosModel = Photos.from(dic)
        
        XCTAssertNotNil(photosModel)
        XCTAssertEqual(photosModel?.photoInfo.count, 2)
    }
}
