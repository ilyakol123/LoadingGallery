//
//  HTTPService.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import Foundation

class HTTPService {
    static let shared = HTTPService()

    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case serverError(statusCode: Int)
        case unknown(Error)
    }

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        body: Encodable? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard var components = URLComponents(string: url) else {
            throw URLError(.badURL)
        }
        components.queryItems = queryItems

        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError
            }
        } catch {
            throw APIError.unknown(error)
        }

    }

}
