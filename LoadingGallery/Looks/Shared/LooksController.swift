//
//  LookController.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import Foundation

class LooksController {
    func getLooks(page: Int, perPage: Int) async throws -> [Look] {
        return try await HTTPService.shared.request(
            url: "https://api.unsplash.com/photos/",
            method: .get,
            queryItems: [
                URLQueryItem(
                    name: "client_id",
                    value: "XMHvdsBfJbDigNmH53iLyPVY6cOyMKXxtVgubtsnFW8"
                ), URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)"),
            ],
            responseType: [Look].self
        )
    }

}
