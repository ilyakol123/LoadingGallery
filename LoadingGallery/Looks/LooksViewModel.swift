//
//  LooksViewModel.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import Foundation
import Observation

@Observable
final class LooksViewModel {
    private let controller = LooksController()

    private(set) var looks: [Look] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var totalLooksCount: Int = 0

    var currentPage = 1
    let pageSize = 3
    var collectionId: Int = 1

    func loadInitialLooks() async {
        currentPage = 1
        await loadLooks(reset: true)
    }

    func loadNextPage() async {
        currentPage += 1
        await loadLooks(reset: false)
    }

    private func loadLooks(reset: Bool) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await controller.getLooks(page: currentPage, collectionId: collectionId)
            totalLooksCount = response.total
            if reset {
                looks = response.looks
                print("Loaded Initial \(response.looks.count) looks")
            } else {
                looks += response.looks
                print("Loaded \(response.looks.count) more looks")
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Ошибка загрузки: \(error)")
        }

        isLoading = false
    }
    
    func toggleBookmark(for lookId: Int) {
            guard let index = looks.firstIndex(where: { $0.id == lookId }) else { return }
            looks[index].isBookmarked.toggle()
        }
}
