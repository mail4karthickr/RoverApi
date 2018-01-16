//
//  SceneCordinatorType.swift
//  Nasa
//
//  Created by karthick on 12/19/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    //transition to another scene
    @discardableResult
    func transition(to scene: SceneType, type: SceneTransitionType) -> Completable
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
