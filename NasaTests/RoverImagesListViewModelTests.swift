//
//  RoverImagesListViewModelTests.swift
//  NasaTests
//
//  Created by karthick on 1/5/18.
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

class RoverImagesListViewModelTests: XCTestCase {
    
    var scheduler: ConcurrentDispatchQueueScheduler!
    var provider: MoyaProvider<MarsRoverApiService>!
    var roverImagesListViewModel: RoverImagesListViewModel!
    var sceneCoordinator: SceneCoordinator!
    var imageCacheServiceType: ImageCacheService!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        imageCacheServiceType = ImageCacheService()
        let window = UIWindow()
        window.rootViewController = UIViewController()
        sceneCoordinator = SceneCoordinator(window: window)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testGetMarsRoverPhotosShouldReturnPhotos() {
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        
        let photosObservable = roverImagesListViewModel.getMarsRoverPhotos(date: Date().dateFromString(string: "2014-12-25")!)
        let result = try! photosObservable.toBlocking().first()!
        
        XCTAssertEqual(result.photoInfo.count, 4)
        XCTAssertEqual(result.photoInfo.first?.imageSrc.absoluteString, "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01004/opgs/edr/fcam/FLB_486615455EDR_F0481570FHAZ00323M_.JPG")
    }
    
    func testGetMarsRoverImagesForMissingImgSrc() {
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotosMissingImgSrc, stubClosure: MoyaProvider.immediatelyStub)
        roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        
        let photosObservable = roverImagesListViewModel.getMarsRoverPhotos(date: Date().dateFromString(string: "2014-12-25")!)
        var errored = false
        do {
            guard let _ = try photosObservable.toBlocking().first() else { return }
        } catch {
            errored = true
        }
        
        XCTAssertTrue(errored)
    }
    
    let endPointClosureForGetPhotos = { (target: MarsRoverApiService) -> Endpoint<MarsRoverApiService> in
        return Endpoint(url: "test", sampleResponseClosure: {.networkResponse(200, stubbedResponse("GetPhotos"))}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    }
    
    let endPointClosureForGetPhotosMissingImgSrc = { (target: MarsRoverApiService) -> Endpoint<MarsRoverApiService> in
        return Endpoint(url: "test", sampleResponseClosure: {.networkResponse(200, stubbedResponse("GetPhotosMissingImgSrc"))}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    }
    
    
}
