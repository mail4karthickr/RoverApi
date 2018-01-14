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
     func imageFromCacheWithUrl(name: String) -> UIImage?
     func removeImageFromCache(imageName: String) -> Bool
}

struct ImageCacheService: ImageCacheServiceType {
    
    func saveImageToCache(data: Data, imageName: String) -> Bool {
        let path = filePathAtDocumentsDirectory(imageName: imageName)
        guard let _ = try? data.write(to: path) else {
            return false
        }
        return true
    }
    
    func imageFromCacheWithUrl(name: String) -> UIImage? {
        if fileExistsAtPath(imageName: name) {
            let imageUrl = filePathAtDocumentsDirectory(imageName: name)
            return UIImage(contentsOfFile: imageUrl.path)
        }
        return nil
    }
    
    func removeImageFromCache(imageName: String) -> Bool {
        if fileExistsAtPath(imageName: imageName) {
            return removeItemFromDocumentsDirectory(itemName: imageName)
        }
        return false
    }
    
    func removeItemFromDocumentsDirectory(itemName: String) -> Bool {
        guard let _ = try? FileManager.default.removeItem(at: filePathAtDocumentsDirectory(imageName: "testPhoto")) else {
            return false
        }
        return true
    }
    
    private func fileExistsAtPath(imageName: String) -> Bool {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(imageName)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    private func filePathAtDocumentsDirectory(imageName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(imageName)
    }
    
}
