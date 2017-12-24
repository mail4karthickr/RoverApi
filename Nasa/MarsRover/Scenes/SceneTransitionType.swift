//
//  SceneTransitionType.swift
//  Nasa
//
//  Created by karthick on 12/20/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import Foundation

enum SceneTransitionType {
    case root   // make view controller the root view controller
    case push   // push view controller to navigation stack
    case modal  // present view controller modally
}
