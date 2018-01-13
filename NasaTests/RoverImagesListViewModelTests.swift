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
  
    var provider: MoyaProvider<MarsRoverApiService>!
    var roverImagesListViewModel: RoverImagesListViewModel!
    var sceneCoordinator: SceneCoordinatorType!
    var imageCacheServiceType: ImageCacheServiceType!
    let disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    var subscription: Disposable!
    
    override func setUp() {
        super.setUp()
        imageCacheServiceType = ImageCacheService()
        let window = UIWindow()
        window.rootViewController = UIViewController()
        sceneCoordinator = SceneCoordinator(window: window)
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testIntializer() {
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        
        XCTAssertNotNil(roverImagesListViewModel.sceneCoordinator)
        XCTAssertNotNil(roverImagesListViewModel.provider)
        XCTAssertNotNil(roverImagesListViewModel.imageCache)
    }
    
    func testGetMarsRoverPhotosForValidJson() {
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        
        let photosObservable = roverImagesListViewModel.getMarsRoverPhotos(date: Date().dateFromString(string: "2014-12-25")!)
        let result = try! photosObservable.toBlocking().first()!
        
        XCTAssertEqual(result.photoInfo.count, 4)
        XCTAssertEqual(result.photoInfo.first?.imageSrc.absoluteString, "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01004/opgs/edr/fcam/FLB_486615455EDR_F0481570FHAZ00323M_.JPG")
    }
    
    func testGetMarsRoverPhotosForMissingImgSrcInJson() {
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
    
    func testGetMarsRoverImageUrlsForValidPhotoDetailsArray() {
        class MockRoverImagesListViewModel: RoverImagesListViewModel {
            override func getMarsRoverPhotos(date: Date) -> Observable<Photos> {
                return Observable.just(PhotosMock.getMockPhoto())
            }
        }
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        let mockRoverImagesListViewModel = MockRoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        let response = mockRoverImagesListViewModel.getMarsRoverImageUrls(date: Date.init())
        
        let result = try! response.toBlocking().first()!
        
        XCTAssertTrue(result.isSuccess)
        XCTAssertNotNil(result.value)
        XCTAssertEqual(result.value?.count, PhotosMock.getMockPhoto().photoInfo.count)
        XCTAssertFalse(mockRoverImagesListViewModel.showLoadingIndicator.value)
    }
    
    func testGetMarsRoverImageUrlsWhenPhotoDetailsArrayIsEmpty() {
        class MockRoverImagesListViewModel: RoverImagesListViewModel {
            override func getMarsRoverPhotos(date: Date) -> Observable<Photos> {
                return Observable.just(PhotosMock.getEmptyPhotoDetailsMock())
            }
        }
        
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        let mockRoverImagesListViewModel = MockRoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        let response = mockRoverImagesListViewModel.getMarsRoverImageUrls(date: Date.init())
        
        let result = try! response.toBlocking().first()!
        
        XCTAssertTrue(result.isFailure)
        XCTAssertNotNil(result.error)
        let apiError = result.error as! MarsRoverApiError
        XCTAssertEqual(apiError.errorMessage, MarsRoverApiError.imageNotFound.errorMessage)
        XCTAssertFalse(mockRoverImagesListViewModel.showLoadingIndicator.value)
    }
    
    func testGetMarsRoverImageFromCache() {
        
        //save image to cache.
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: "testPhoto", ofType: "png")!
        if !imageCacheServiceType.saveImageToCache(data: UIImagePNGRepresentation(UIImage(named: filePath)!)!, imageName: "testPhoto") {
            XCTFail("Image cannot be saved in documents directory")
        }

        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        let roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        let response = roverImagesListViewModel.getMarsRoverImages(imageUrl: URL(string: "http://www.google.com/testPhoto")!)
        
        let result = try! response.toBlocking().first()!
        XCTAssertNotNil(result)
    }
    
    func testGetMarsRoverImageFromApi() {
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        
        let photosObservable = roverImagesListViewModel.getMarsRoverImages(imageUrl: URL(string: "http://www.google.com/testPhoto")!)
        let result = try! photosObservable.toBlocking().first()!
        
        XCTAssertNotNil(result.value)
    }
    
    func testDatePickerActionWhenTitleIsDate() {
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        
        _ = roverImagesListViewModel.showDatePicker.execute("Date").toBlocking()
        
        XCTAssertFalse(roverImagesListViewModel.datePickerIsHidden.value)
        XCTAssertEqual(roverImagesListViewModel.barButtonTitle.value, "Done")
    }
    
    func testDatePickerActionWhenTitleIsDone() {
        provider = MoyaProvider<MarsRoverApiService>(endpointClosure: endPointClosureForGetPhotos, stubClosure: MoyaProvider.immediatelyStub)
        roverImagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCacheServiceType)
        
        _ = roverImagesListViewModel.showDatePicker.execute("Done").toBlocking()
        
        XCTAssertTrue(roverImagesListViewModel.datePickerIsHidden.value)
        XCTAssertTrue(roverImagesListViewModel.showLoadingIndicator.value)
        XCTAssertTrue(roverImagesListViewModel.startDownloadingImageUrls.value)
        XCTAssertEqual(roverImagesListViewModel.barButtonTitle.value, "Date")
    }
    
    override func tearDown() {
        //remove the cahced test image.
        _ = imageCacheServiceType.removeImageFromCache(imageName: "testPhoto")
        super.tearDown()
    }
    
    let endPointClosureForGetPhotos = { (target: MarsRoverApiService) -> Endpoint<MarsRoverApiService> in
        return Endpoint(url: "test", sampleResponseClosure: {.networkResponse(200, stubbedResponse("GetPhotos"))}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    }
    
    let endPointClosureForGetPhotosMissingImgSrc = { (target: MarsRoverApiService) -> Endpoint<MarsRoverApiService> in
        return Endpoint(url: "test", sampleResponseClosure: {.networkResponse(200, stubbedResponse("GetPhotosMissingImgSrc"))}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        
    }
    
}
