//
//  LooksGridViewScreen.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 25.06.2025.
//

import SwiftUI

struct LooksGridViewScreen: View {
    var onImageTap: (Int) -> Void

    var viewModel: LooksViewModel
    
    let columns = [
        GridItem(.flexible(), alignment: .bottom),
        GridItem(.flexible(), alignment: .bottom),
        GridItem(.flexible(), alignment: .bottom),
    ]

    var body: some View {
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
                        await viewModel.onAppear()
                    }
                }
            }
    }

    private var gridView: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.looks.indices, id: \.self) { index in
                let look = viewModel.looks[index]

                Button {
                    onImageTap(index)
                } label: {
                    GridViewCell(look: look)
                        .task(id: look.id) {
                            let preloadTriggerIndex =
                                viewModel.looks.count - 13
                            if index == preloadTriggerIndex {
                                await viewModel.loadMoreLooksFrom(
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
    LooksGridViewScreen(onImageTap: { _ in print("Tapped")}, viewModel: LooksViewModel())
}
