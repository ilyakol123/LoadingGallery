//
//  ScrollGalleryScreen.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import SwiftUI

struct LooksScrollViewScreen: View {

    var viewModel: LooksViewModel
    var onBack: () -> Void

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
                                        await viewModel.loadMoreLooksFrom(
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
                                await viewModel.onAppear()
                            }
                            withAnimation(.none) {
                                proxy.scrollTo(viewModel.selectedIndex, anchor: .top)
                            }
                            scrollDisabled = false
                        }
                    }
                }
            Button(action: {
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding()
                    .background(.black.opacity(0.4))
                    .clipShape(Circle())
                    .shadow(color: .white, radius: 21)
                    
            }
            .padding(.horizontal)
            
        }

        //.ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LooksScrollViewScreen(viewModel: LooksViewModel(), onBack: { print("ON back") })
}
