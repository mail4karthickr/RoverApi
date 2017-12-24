//
//  MarsRoverApiError.swift
//  Nasa
//
//  Created by karthick on 12/17/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import Foundation

enum MarsRoverApiError: Error {
    case rerquestFailed
    case imageNotFound
    case networkNotAvailable
    
    var errorMessage: String {
        switch self {
        case .rerquestFailed:
            return "Request failed"
        case .imageNotFound:
            return "Image not found"
        case .networkNotAvailable:
            return "Network not available"
        }
    }
}
