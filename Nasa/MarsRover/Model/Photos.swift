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

struct Photos: Mappable {
    let photoInfo: [PhotoDetails]
    init(map: Mapper) throws {
        try photoInfo = map.from("photos")
    }
}

struct PhotoDetails: Mappable {
    let id: Int
    let sol: Int
    let imageSrc: URL
    init(map: Mapper) throws {
        try id = map.from("id")
        try sol = map.from("sol")
        try imageSrc = map.from("img_src")
    }
}

struct Camera: Mappable {
    let id: Int
    let name: String
    let roverId: Int
    let fullName: String
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try roverId = map.from("rover_id")
        try fullName = map.from("full_name")
    }
}
