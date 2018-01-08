//
//  AppDelegate.swift
//  Nasa
//
//  Created by karthick on 12/15/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let sceneCoordinator = SceneCoordinator(window: window!)
        let provider = MoyaProvider<MarsRoverApiService>()
        let imageCache = ImageCacheService()
        let imagesListViewModel = RoverImagesListViewModel(sceneCoordinator, provider, imageCache)
        let firstScene = Scene.roverImagesList(imagesListViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        return true
    }
}

