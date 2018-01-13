//
//  Photos.swift
//  Nasa
//
//  Created by karthick on 12/16/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import Foundation
import Moya_ModelMapper
import Mapper

public struct Photos {
    let photoInfo: [PhotoDetails]
}

extension Photos: Mappable {
    public init(map: Mapper) throws {
        try photoInfo = map.from("photos")
    }
}

public struct PhotoDetails {
    public let id: Int
    public let sol: Int
    public let imageSrc: URL
}

extension PhotoDetails: Mappable {
    public init(map: Mapper) throws {
        try id = map.from("id")
        try sol = map.from("sol")
        try imageSrc = map.from("img_src")
    }
}

public struct PhotoDetailsSample {
    public let id: Int
    public let sol: Int
    public let imageSrc: URL
}

extension PhotoDetailsSample: Mappable {
    public init(map: Mapper) throws {
        try id = map.from("id")
        try sol = map.from("sol")
        try imageSrc = map.from("img_src")
    }
}


