//
//  Scene+ViewController.swift
//  Nasa
//
//  Created by karthick on 12/20/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .roverImage(let viewModel):
             var vc = storyBoard.instantiateViewController(withIdentifier: "roverImageVc") as! RoverImageViewController
             vc.bindViewModel(to: viewModel)
             return vc;
        case .roverImagesList(let viewModel):
            let nc = storyBoard.instantiateViewController(withIdentifier: "rootNavigationController") as! UINavigationController
            var vc = nc.viewControllers.first as! RoverImagesListViewController
            vc.bindViewModel(to: viewModel)
            return nc
        }
    }
}
