//
//  ScrollGalleryScreen.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import SwiftUI

struct LooksScrollViewScreen: View {

    let viewModel: LooksViewModel
    let startIndex: Int

    @State private var scrollDisabled = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black
                .ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.looks.indices, id: \.self) { index in
                            let look = viewModel.looks[index]

                            SingleLookView(
                                look: look
                            )
                            .id(index)
                            .task {
                                let preloadTriggerIndex =
                                    viewModel.looks.count - 13
                                if index == preloadTriggerIndex {
                                    await viewModel.loadNextIfNeeded(
                                        current: look
                                    )
                                }
                            }
                        }
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollDisabled(scrollDisabled)
                .onAppear {
                    Task {
                        viewModel.showType = .scroll
                        if viewModel.looks.isEmpty {
                            await viewModel.loadInitialLooks()
                        }
                        withAnimation(.none) {
                            proxy.scrollTo(startIndex, anchor: .top)
                        }
                        scrollDisabled = false
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LooksScrollViewScreen(viewModel: LooksViewModel(), startIndex: 0)
}
