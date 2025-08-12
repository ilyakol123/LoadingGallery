//
//  AppRouter.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 12.08.2025.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case scrollView
    
}

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
