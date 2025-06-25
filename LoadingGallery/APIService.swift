//
//  APIService.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import Foundation

final class APIService {
    static let shared = APIService() // Singleton, если нужно

    private init() {}

    func fetch<T: Decodable>(
        method: String = "GET",
        url: URL,
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}

enum APIError: Error {
    case invalidResponse
    case decodingFailed(Error)
}
