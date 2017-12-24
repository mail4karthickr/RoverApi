//
//  MarsRoverPhotosEndPoint.swift
//  Nasa
//
//  Created by karthick on 12/14/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

enum MarsRoverPhotos {
    case marsPhotos(earthDate: Date)
    case getImage(imagePath: String)
}

extension MarsRoverPhotos: TargetType {
    var baseURL: URL
    {
        switch self {
        case .marsPhotos(_):
            return URL(string: "https://api.nasa.gov")!
        case .getImage(_):
            return URL(string: "http://mars.jpl.nasa.gov")!
        }
    }
    
    var path: String {
        switch self {
        case .marsPhotos(_):
            return  "/mars-photos/api/v1/rovers/curiosity/photos"
        case .getImage(let imagePath):
            return imagePath
        }
    }
    
    var sampleData: Data {
        switch self {
        case .marsPhotos(_):
            return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
        case .getImage(_):
            return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .marsPhotos(let date):
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "YYYY-MM-dd"
            let dateStr = dateformatter.string(from: date)
            return .requestParameters(parameters: ["earth_date":dateStr,"api_key": "VisF9qnyxMG0TNDtL0FhmNGBVpwMmCQVyTPPPOmA"], encoding: URLEncoding.queryString)
        case .getImage(_):
            return .requestPlain
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}
