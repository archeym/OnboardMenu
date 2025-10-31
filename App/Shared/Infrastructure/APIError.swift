//
//  APIError.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed(String)
    case noData
    case statusCode(Int, String?)
    case cancelled
    case system(String)
    
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed(let desc):
            return "Request failed: \(desc)"
        case .decodingFailed(let desc):
            return "Failed to decode: \(desc)"
        case .noData:
            return "No data from server."
        case .statusCode(let code, let message):
            if let message, !message.isEmpty {
                return "HTTP \(code): \(message)"
            } else {
                return "HTTP \(code)."
            }
        case .cancelled:
            return "Cancelled."
        case .system(let desc):
            return desc
        }
    }
}

extension APIError {
    var isCancelled: Bool {
        if case .cancelled = self {
            return true
        }
        return false
    }
}
