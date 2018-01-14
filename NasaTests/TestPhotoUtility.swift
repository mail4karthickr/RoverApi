//
//  TestPhotoUtility.swift
//  NasaTests
//
//  Created by karthick on 1/13/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit

class TestPhotoUtility {
    func getTestPhotoData() -> Data {
        return UIImagePNGRepresentation(getTestPhoto())!
    }
    
    func getTestPhoto() -> UIImage {
        return UIImage(named: getTestPhotoPath())!
    }
    
    func getTestPhotoPath() -> String {
        let testBundle = Bundle(for: type(of: self))
        return testBundle.path(forResource: "testPhoto", ofType: "png")!
    }
}
