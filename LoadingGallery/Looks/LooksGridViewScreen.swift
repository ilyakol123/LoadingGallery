//
//  LooksGridViewScreen.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import SwiftUI

struct LooksGridViewScreen: View {

    @State private var viewModel = LooksViewModel()
    let columns = [
        GridItem(.flexible(), alignment: .bottom),
        GridItem(.flexible(), alignment: .bottom),
        GridItem(.flexible(), alignment: .bottom),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                ScrollView {
                    gridView

                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
                .scrollIndicators(.hidden)
                .task {
                    viewModel.showType = .grid
                    if viewModel.looks.isEmpty {
                        await viewModel.loadInitialLooks()
                    }
                }
                .navigationDestination(for: Int.self) { index in
                    LooksScrollViewScreen(
                        viewModel: viewModel,
                        startIndex: index
                    )
                }
            }
        }
    }

    private var gridView: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.looks.indices, id: \.self) { index in
                let look = viewModel.looks[index]

                NavigationLink(value: index) {
                    GridViewCell(look: look)
                        .task(id: look.id) {

                            let preloadTriggerIndex =
                                viewModel.looks.count - 13
                            if index == preloadTriggerIndex {
                                await viewModel.loadNextIfNeeded(
                                    current: look
                                )
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    LooksGridViewScreen()
}
