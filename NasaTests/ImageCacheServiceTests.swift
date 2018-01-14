//
//  ImageCacheServiceTests.swift
//  NasaTests
//
//  Created by karthick on 1/13/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation

import Foundation
import XCTest
import RxTest
import Moya
import RxBlocking
import RxSwift
import SwiftyJSON
import Moya_ModelMapper
@testable import Nasa

class ImageCacheServiceTests: XCTestCase {
    var imageCacheService: ImageCacheService!
    
    override func setUp() {
        super.setUp()
        imageCacheService = ImageCacheService()
    }
    
    func testSaveImageToCache() {
        let val = imageCacheService.saveImageToCache(data: TestPhotoUtility().getTestPhotoData(), imageName: "testPhoto")
        XCTAssertTrue(val)
        XCTAssertNotNil(imageCacheService.getImageFromCache(imageName: "testPhoto"))
    }
    
    func testSaveImageToCacheForInvaliDocDir() {
        class MockImageCacheService: ImageCacheService {
            override func docDirPathForImageWith(imageName: String) -> URL {
                return URL(string: "http://www.google.com")!
            }
        }
        let mockImageCacheService = MockImageCacheService()
        let isImageSaved = mockImageCacheService.saveImageToCache(data: TestPhotoUtility().getTestPhotoData(), imageName: "testPhoto")
        let imageSearchResult = mockImageCacheService.getImageFromCache(imageName: "testPhoto")
        
        XCTAssertFalse(isImageSaved)
        XCTAssertNil(imageSearchResult)
    }
    
    func testGetImageFromCache() {
        if !imageCacheService.saveImageToCache(data: TestPhotoUtility().getTestPhotoData(), imageName: "testPhoto") {
            XCTFail("TestGetImageFromCache - Failed - Image could not be saved to cache")
        }
        
        let cachedImage = imageCacheService.getImageFromCache(imageName: "testPhoto")
        
        XCTAssertNotNil(cachedImage)
    }
    
    func testGetImageFromCacheForInvalidPath() {
        if !imageCacheService.saveImageToCache(data: TestPhotoUtility().getTestPhotoData(), imageName: "testPhoto") {
            XCTFail("TestGetImageFromCache - Failed - Image could not be saved to cache")
        }
        
        let cachedImage = imageCacheService.getImageFromCache(imageName: "testPhoto1")
        
        XCTAssertNil(cachedImage)
    }
    
    func testRemoveImageFromCache() {
        if !imageCacheService.saveImageToCache(data: TestPhotoUtility().getTestPhotoData(), imageName: "testPhoto") {
            XCTFail("TestGetImageFromCache - Failed - Image could not be saved to cache")
        }
        
        let isImageRemoved = imageCacheService.removeImageFromCache(imageName: "testPhoto")
        let cachedImage = imageCacheService.getImageFromCache(imageName: "testPhoto")
        
        XCTAssertNil(cachedImage)
        XCTAssertTrue(isImageRemoved)
    }
    
    func testRemoveImageFromCacheForInvalidImageName() {
        if !imageCacheService.saveImageToCache(data: TestPhotoUtility().getTestPhotoData(), imageName: "testPhoto") {
            XCTFail("TestGetImageFromCache - Failed - Image could not be saved to cache")
        }
        
        let isImageRemoved = imageCacheService.removeImageFromCache(imageName: "testPhoto1")

        XCTAssertFalse(isImageRemoved)
    }
    
    func testImageExistsAtPath() {
        if !imageCacheService.saveImageToCache(data: TestPhotoUtility().getTestPhotoData(), imageName: "testPhoto") {
            XCTFail("TestGetImageFromCache - Failed - Image could not be saved to cache")
        }
        let imageExists = imageCacheService.imageExistsInCache(imageName: "testPhoto")
        
        XCTAssertTrue(imageExists)
    }
    
    func testImageExistsAtPathForInvalidImageName() {
        let imageExists = imageCacheService.imageExistsInCache(imageName: "testPhoto1")
        XCTAssertFalse(imageExists)
    }
    
    func testDocDirPathForImage() {
        let imagePath = imageCacheService.docDirPathForImageWith(imageName: "testPhoto")
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let expectedDocDirPath = documentsURL.appendingPathComponent("testPhoto")
        
        XCTAssertEqual(imagePath, expectedDocDirPath)
        
    }

    override func tearDown() {
        _ = imageCacheService.removeImageFromCache(imageName: TestPhotoUtility().getTestPhotoPath())
        super.tearDown()
    }
}
