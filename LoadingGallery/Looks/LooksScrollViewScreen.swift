//
//  ScrollGalleryScreen.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import SwiftUI

struct LooksScrollViewScreen: View {

    @State var viewModel = LooksViewModel()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                LazyVStack {
                    ForEach(viewModel.looks) { look in
                        SingleLookView(
                            look: look,
                            lookNumber: look.id,
                            totalNumberOfLooks: viewModel.totalLooksCount,
                            onBookmarkToggle: {
                                viewModel.toggleBookmark(for: look.id)
                            }
                        )
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.totalLooksCount > viewModel.looks.count {
                        Button("Load more") {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.loadInitialLooks()
            }

        }
    }
}

#Preview {
    LooksScrollViewScreen()
}
