//
//  ImageCache.swift
//  Nasa
//
//  Created by karthick on 12/17/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit

protocol ImageCacheServiceType {
     func saveImageToCache(data: Data, imageName: String) -> Bool
     func getImageFromCache(imageName: String) -> UIImage?
     func removeImageFromCache(imageName: String) -> Bool
}

class ImageCacheService: ImageCacheServiceType {
    
    func saveImageToCache(data: Data, imageName: String) -> Bool {
        let path = docDirPathForImageWith(imageName: imageName)
        guard let _ = try? data.write(to: path) else {
            return false
        }
        return true
    }
    
    func getImageFromCache(imageName: String) -> UIImage? {
        if imageExistsInCache(imageName: imageName) {
            let imageUrl = docDirPathForImageWith(imageName: imageName)
            return UIImage(contentsOfFile: imageUrl.path)
        }
        return nil
    }
    
    func removeImageFromCache(imageName: String) -> Bool {
        if imageExistsInCache(imageName: imageName), let _ = try? FileManager.default.removeItem(at: docDirPathForImageWith(imageName: "testPhoto"))  {
            return true
        }
        return false
    }
    
    func imageExistsInCache(imageName: String) -> Bool {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(imageName)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    func docDirPathForImageWith(imageName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(imageName)
    }
    
}
