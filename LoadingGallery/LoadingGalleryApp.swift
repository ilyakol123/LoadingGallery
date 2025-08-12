//
//  LoadingGalleryApp.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import SwiftUI

@main
struct LoadingGalleryApp: App {

    @StateObject private var router = AppRouter()
    @StateObject private var coordinator: LooksCoordinator

    init() {
        let router = AppRouter()
        _router = StateObject(wrappedValue: router)
        _coordinator = StateObject(
            wrappedValue: LooksCoordinator(router: router)
        )
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                coordinator.start()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .scrollView:
                            coordinator.scrollViewScreen()
                        }
                    }
            }
        }
    }
}
