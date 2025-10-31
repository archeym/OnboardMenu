//
//  APIClient.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import Foundation

struct APIClient {
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    ///Generic network request
    func request<T: Decodable>(_ type: T.Type, url: URL, method: HTTPMethod = .GET, body: Data? = nil) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        do {
            let (data, response) = try await session.data(for: request)// Perform the HTTP request (async)

            guard let http = response as? HTTPURLResponse else {
                throw APIError.requestFailed("No HTTPURLResponse")
            }

            guard (200...299).contains(http.statusCode) else {
                let bodyStr = String(data: data, encoding: .utf8)
                throw APIError.statusCode(http.statusCode, bodyStr)
            }

            do {
                let decoder = JSONDecoder()//Decode JSON into the caller's model type T
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch let err as DecodingError {//Catches only DecodingError from the decode step or bad JSON
                throw APIError.decodingFailed(String(describing: err))
            }
        } catch is CancellationError {
            throw APIError.cancelled
        } catch {
            let ns = error as NSError
            if ns.code == NSURLErrorCancelled {//Special-cases cancellation: if view disappeared, Task cancelled, you rethrow CancellationError()
                throw CancellationError()
            }
            throw APIError.system(error.localizedDescription)
        }
    }

    ///For sending an Encodable body as JSON
    func request<T: Decodable, B: Encodable>(_ type: T.Type, url: URL, method: HTTPMethod = .POST, jsonBody: B) async throws -> T {
        let data = try JSONEncoder().encode(jsonBody)
        return try await request(type, url: url, method: method, body: data)
    }
}
