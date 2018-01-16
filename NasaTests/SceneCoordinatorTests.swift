//
//  SceneCoordinatorTests.swift
//  NasaTests
//
//  Created by karthick on 1/14/18.
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

class SceneCoordinatorTests: XCTestCase {
    var sceneCoordinator: SceneCoordinator!
    var mockRootViewController: UIViewController!
    var window: UIWindow!
    
    override func setUp() {
        window = UIWindow()
        window.rootViewController = UIViewController()
        sceneCoordinator = SceneCoordinator(window: window)
        mockRootViewController = UIViewController()
        super.setUp()
    }
    
    func testActualViewController() {
        let testViewController = UIViewController()
        let actualViewController = sceneCoordinator.actualViewController(for: testViewController)
        XCTAssertEqual(testViewController, actualViewController)
    }
    
    func testActualViewControllerForNavCtrl() {
        let testRootViewController = UIViewController()
        let testNavController = UINavigationController(rootViewController: testRootViewController)
        let actualViewController = sceneCoordinator.actualViewController(for: testNavController)
        XCTAssertEqual(testRootViewController, actualViewController)
    }
    
    func testTransitionToForRoot() {
        class MockSceneCoordinator: SceneCoordinator {
            override func actualViewController(for viewController: UIViewController) -> UIViewController {
                return MockViewController.getMockViewController()
            }
        }
        sceneCoordinator.transition(to: MockScene.test, type: .root)
        XCTAssertTrue(window.rootViewController == MockViewController.getMockViewController(), "Window root viewcontroller and mockrootviewcontroller are not equal")
    }
    
    func testTransitionToForPushVc() {
        window = UIWindow()
        let mockRootVc = UIViewController()
        let navCtrl = UINavigationController(rootViewController: mockRootVc)
        window.rootViewController = mockRootVc
        sceneCoordinator = SceneCoordinator(window: window)
        sceneCoordinator.transition(to: MockScene.test, type: .push)
        XCTAssertTrue(navCtrl.topViewController! == MockViewController.getMockViewController(), "Window root viewcontroller and mockrootviewcontroller are not equal")
    }
}

enum MockScene {
    case test
}

extension MockScene: SceneType {
    func viewController() -> UIViewController {
        return MockViewController.getMockViewController()
    }
}

class MockViewController: UIViewController {
    static let viewController = UIViewController()
    static func getMockViewController() -> UIViewController {
        viewController.accessibilityLabel = "mockVc"
        return viewController
    }
}
