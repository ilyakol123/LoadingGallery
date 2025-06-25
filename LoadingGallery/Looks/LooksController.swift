//
//  LookController.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import Foundation

struct LooksResponse: Decodable {
    let page: Int
    let pageSize: Int
    let total: Int
    let looks: [Look]
}

class LooksController {
    func getLooks(page: Int, collectionId: Int) async throws -> LooksResponse {
        guard let url = URL(string: "https://d2d76753-e425-44ef-a689-e39fc8afbf9f.mock.pstmn.io/api/looks?page=\(page)&collectionId=\(collectionId)") else {
            throw URLError(.badURL)
        }

        return try await APIService.shared.fetch(url: url, responseType: LooksResponse.self)
    }

}
