//
//  LooksViewModel.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import Foundation
import Observation
import UIKit

@Observable
final class LooksViewModel {

    private let controller = LooksController()

    private(set) var looks: [Look] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    enum ShowType {
        case scroll
        case grid
    }
    var showType: ShowType = .scroll
    var currentPage = Int.random(in: 1...1000)

    private let pageSize = 24
    private var loadedPages: Set<Int> = []
    var selectedIndex: Int = 0

    func onAppear() async {
        print("Start initial loading")
        await onScroll()
        print("Inital loading finished")
    }

    func loadMoreLooksFrom(current: Look) async {
        
        guard let index = looks.firstIndex(where: { $0.id == current.id })
        else { return }
        
        let thresholdIndex = looks.count - 13
        if index == thresholdIndex && !isLoading
            && !loadedPages.contains(currentPage + 1)
        {
            print("Reached look to load more - current index = \(index)")
            await loadNextPage()
        }
    }

    private func onScroll() async {
        print("Start loading looks page \(currentPage)")
        isLoading = true
        errorMessage = nil
        do {
            var fetchedLooks = try await controller.getLooks(
                page: currentPage,
                perPage: pageSize
            )

            for i in fetchedLooks.indices {
                let url = fetchedLooks[i].imageURL
                if let data = try? Data(contentsOf: url),
                    let uiImage = UIImage(data: data)
                {
                    fetchedLooks[i].image = uiImage
                }
            }

            if currentPage == 1 {
                looks = fetchedLooks

                print("Loaded looks page 1: \(fetchedLooks.count)")
            } else {
                looks += fetchedLooks
                print(
                    "From page \(currentPage): loaded looks = \(fetchedLooks.count)"
                )
            }

        } catch {
            errorMessage = error.localizedDescription
            print("Ошибка загрузки: \(error)")
        }
        isLoading = false
    }

    private func loadNextPage() async {
        print("Started loading next page - \(currentPage + 1)")
        currentPage += 1
        loadedPages.insert(currentPage)
        await onScroll()
    }

}
