//
//  MarsRoverPhotosViewModel.swift
//  Nasa
//
//  Created by karthick on 12/16/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import AlamofireImage
import RxCocoa
import Action
import RxOptional
import Alamofire

struct RoverImagesListViewModel {
    let provider: MoyaProvider<MarsRoverApiService>
    let imageCache: ImageCacheServiceType
    let sceneCoordinator: SceneCoordinatorType
    
    let datePickerIsHidden = Variable<Bool>(true)
    let showLoadingIndicator = Variable<Bool>(true)
    let barButtonTitle = Variable<String>("Date")
    let startDownloadingImageUrls = Variable<Bool>(false)
    
    init(_ coordinator: SceneCoordinatorType,_ provider: MoyaProvider<MarsRoverApiService>,_ imageCache: ImageCacheServiceType) {
        self.sceneCoordinator = coordinator
        self.imageCache = imageCache
        self.provider = provider
    }
    
    lazy var showDatePicker: Action<String, Swift.Never> = { this in
        return Action { title in
            if title == "Date" {
                this.datePickerIsHidden.value = false
                this.barButtonTitle.value = "Done"
            } else {
                this.datePickerIsHidden.value = true
                this.barButtonTitle.value = "Date"
                this.showLoadingIndicator.value = true
                this.startDownloadingImageUrls.value = true
            }
            return Observable.empty()
        }
    }(self)
    
    func getMarsRoverPhotos(date: Date) -> Observable<Photos> {
        return self.provider.rx.request(MarsRoverApiService.marsPhotos(earthDate: date))
            .map(to: Photos.self)
            .asObservable()
            .catchError { error in
                    throw error
            }
    }
    
    func getMarsRoverImageUrls(date: Date) -> Observable<Result<[URL]>> {
        return self.getMarsRoverPhotos(date: date)
            .map { $0.photoInfo.map { $0.imageSrc } }
            .errorOnEmpty()
            .map {
                self.showLoadingIndicator.value = false
                return .success($0)
            }
            .catchError { error in
                return Observable.just(.failure(MarsRoverApiError.imageNotFound))
            }
        
    }
    
    func getMarsRoverImages(imageUrl: URL) -> Observable<UIImage?> {
        if let cachedImage = imageCache.imageFromCacheWithUrl(name: imageUrl.lastPathComponent) {
            return Observable.just(cachedImage)
        } else {
            return self.provider.rx.request(MarsRoverApiService.getImage(imagePath: imageUrl.relativePath))
                .map { response in
                        let _ = self.imageCache.saveImageToCache(data: response.data, imageName: imageUrl.lastPathComponent)
                        return response
                }
                .mapImage()
                .asObservable()
        }
    }
    
    lazy var tapAction: Action<UIImage, Swift.Never> = { this in
        return Action { image in
            let roverImageViewModel = RoverImageViewModel(image: image, coordinator: this.sceneCoordinator)
            return this.sceneCoordinator
                .transition(to: Scene.roverImage(roverImageViewModel), type: .push)
                .asObservable()
            }
    }(self)
}
