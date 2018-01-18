//
//  MarsRoverApiServiceTests.swift
//  NasaTests
//
//  Created by karthick on 1/16/18.
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

class MarsRoverApiServicesTests: XCTestCase {
    var provider: MoyaProvider<MarsRoverApiService>!
    
    override func setUp() {
        super.setUp()
        provider = MoyaProvider<MarsRoverApiService>(stubClosure: MoyaProvider.immediatelyStub)
    }
    func testGetMarsPhotos() {
        let marsRoverApiService = MarsRoverApiService.marsPhotos(earthDate: Date.init())
        guard let response = try? provider.rx.request(MarsRoverApiService.marsPhotos(earthDate: Date.init())).asObservable().toBlocking().first() else {
            XCTFail("testGetMarsPhotos test failed")
            return
        }
        
        let responseData = response.value?.data
        XCTAssertNotNil(responseData)
        
        XCTAssertEqual(stubbedResponse("GetPhotos"), response.value?.data)
        XCTAssertEqual(marsRoverApiService.baseURL, URL(string: "https://api.nasa.gov")!)
        XCTAssertEqual(marsRoverApiService.path, "/mars-photos/api/v1/rovers/curiosity/photos")
        XCTAssertNil(marsRoverApiService.headers)
        XCTAssertEqual(marsRoverApiService.method, .get)
    }
    
    func testGetMarsRoverImage() {
        let marsRoverApiService = MarsRoverApiService.getImage(imagePath: "mockImagePath")
        guard let response = try? provider.rx.request(MarsRoverApiService.getImage(imagePath: "mockImagePath")).asObservable().toBlocking().first() else {
            XCTFail("testGetMarsRoverImage test failed")
            return
        }
        
        let responseData = response.value?.data
        XCTAssertNotNil(responseData)
        
        XCTAssertEqual(TestPhotoUtility().getTestPhotoData(), response.value?.data)
        XCTAssertEqual(marsRoverApiService.baseURL, URL(string: "http://mars.jpl.nasa.gov")!)
        XCTAssertEqual(marsRoverApiService.path, "mockImagePath")
        XCTAssertNil(marsRoverApiService.headers)
        XCTAssertEqual(marsRoverApiService.method, .get)
    }
}
