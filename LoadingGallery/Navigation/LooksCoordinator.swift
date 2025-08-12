//
//  LooksCoordinator.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 12.08.2025.
//

import Foundation
import SwiftUI

final class LooksCoordinator: ObservableObject {
    private let router: AppRouter
    private let looksViewModel = LooksViewModel()

    init(router: AppRouter) {
        self.router = router
    }

    func start() -> some View {
        LooksGridViewScreen(
            onImageTap: { [weak self] index in
                self?.looksViewModel.selectedIndex = index
                self?.router.push(.scrollView)
            },
            viewModel: looksViewModel
        )
    }
    
    func scrollViewScreen() -> some View {
        LooksScrollViewScreen(
            viewModel: looksViewModel,
            onBack: { [weak self] in
                self?.router.pop()
            }
        )
    }
}
