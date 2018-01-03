//
//  MarsRoverApiError.swift
//  Nasa
//
//  Created by karthick on 12/17/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import Foundation
import Moya

enum MarsRoverApiError: Error {
    case requestFailed(forImageUrl: String, response: Response)
    case imageNotFound
    case networkNotAvailable
    case noImageUrlsFound
    case unknownError
    
    var errorMessage: String {
        switch self {
        case .requestFailed:
            return "Request failed"
        case .imageNotFound:
            return "Image not found"
        case .networkNotAvailable:
            return "Network not available"
        case .noImageUrlsFound:
            return "No images found. Please choose a different date."
        case .unknownError:
            return "unknown error"
        }
    }
}
