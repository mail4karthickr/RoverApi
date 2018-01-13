//
//  User.swift
//  Nasa
//
//  Created by karthick on 1/12/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation
import Mapper

struct User: Mappable {
    public let firstName: String
    public let lastName: String
    
    init(map: Mapper) throws {
        try firstName = map.from("fname")
        try lastName = map.from("lname")
    }
    
}
