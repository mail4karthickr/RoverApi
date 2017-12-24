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
import Alamofire
import RxCocoa
import Action

struct RoverImagesListViewModel {
    let provider = MoyaProvider<MarsRoverPhotos>()
    let imageCache = ImageCache()
    let sceneCoordinator: SceneCoordinatorType
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    internal func getMarsRoverPhotos(date: Date) -> Observable<Photos> {
        return self.provider.rx.request(MarsRoverPhotos.marsPhotos(earthDate: date))
            .map(to: Photos.self)
            .asObservable()
    }
    
    internal func getMarsRoverImageUrls(date: Date) -> Observable<[URL]> {
        return self.getMarsRoverPhotos(date: date)
            .map { return $0.photoInfo.map { $0.imageSrc }}
    }
    
    internal func getMarsRoverImages(imageUrl: URL) -> Observable<UIImage?> {
        if let cachedImage = imageCache.imageFromCacheWithUrl(name: imageUrl.lastPathComponent) {
            return Observable.just(cachedImage)
        } else {
            return self.provider.rx.request(MarsRoverPhotos.getImage(imagePath: imageUrl.relativePath))
                .map { response in
                    if 200 ..< 300 ~= response.statusCode {
                        let _ = self.imageCache.saveImageToCache(data: response.data, imageName: imageUrl.lastPathComponent)
                        return response
                    } else {
                        throw MarsRoverApiError.rerquestFailed
                    }
                }
                .mapImage()
                .asObservable()
            }
        }
    
//    internal func onOpenImage(image: UIImage) {
//            let roverImageViewModel = RoverImageViewModel(image: image, coordinator: self.sceneCoordinator)
//            return self.sceneCoordinator.transition(to: Scene.roverImage(roverImageViewModel), type: .push)
//                .asObservable().map { _ in }
//    }
}
