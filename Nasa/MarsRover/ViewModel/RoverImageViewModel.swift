//
//  RoverImageViewModel.swift
//  Nasa
//
//  Created by karthick on 12/19/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit
import Action

struct RoverImageViewModel {
    
    let coordinator: SceneCoordinatorType
    let image: UIImage
    
    init(image: UIImage, coordinator: SceneCoordinatorType) {
        self.coordinator = coordinator
        self.image = image
    }
    
    lazy var backButtonAction = { this in
        return CocoaAction {
            return this.coordinator.pop()
                .asObservable().map { _ in }
        }
    }(self)
}
