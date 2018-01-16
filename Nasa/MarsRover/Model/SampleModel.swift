//
//  SampleModel.swift
//  Nasa
//
//  Created by karthick on 1/8/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import Moya_ModelMapper
import Mapper

public struct User {
    let firstName: String
    let lastName: String
}

extension User: Mappable {
    public init(map: Mapper) throws {
        try firstName = map.from("fname")
        try lastName = map.from("lname")
    }
}
