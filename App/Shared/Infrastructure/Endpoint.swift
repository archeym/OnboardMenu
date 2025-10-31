//
//  Endpoint.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

enum Endpoint: String {
    
    case merchant

    func url(_ paths: [PathComponent] = [], queryItems: [URLQueryItem] = []) -> URL {
        let apiURL = APIEnvironment.baseURL
            .appendingPathComponent("api", isDirectory: true)
            .appendingPathComponent(rawValue, isDirectory: false)

        let built = paths.reduce(apiURL) { acc, next in
            next.rawValue.isEmpty ? acc : acc.appendingPathComponent(next.rawValue, isDirectory: false)
        }

        guard !queryItems.isEmpty else { return built }
        var comps = URLComponents(url: built, resolvingAgainstBaseURL: true)
        comps?.queryItems = queryItems
        return comps?.url ?? built
    }

    func url(_ paths: PathComponent..., queryItems: URLQueryItem...) -> URL {
        url(paths, queryItems: queryItems)
    }
    
    func url(_ paths: PathComponent..., queryItems: [URLQueryItem]) -> URL {
        url(paths, queryItems: queryItems)
    }
}

extension Endpoint {
    
    enum PathComponent {
        
        case id(String)
        case merchantId
        case menu
        
        var rawValue: String {
            switch self {
            case let .id(id): 
                return "\(id)"
            case .merchantId: 
                return "merchantId"
            case .menu: 
                return "menu"
            }
        }
    }
}

