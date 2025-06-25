//
//  ImageView.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import SwiftUI

struct SingleLookView: View {
    let look: Look
    let lookNumber: Int
    let totalNumberOfLooks: Int
    let onBookmarkToggle: () -> Void
    
    @State private var retryCount = 0

    var body: some View {
        VStack {
            image
            HStack {
                Text("Look \(lookNumber) / \(totalNumberOfLooks)")
                    .textCase(.uppercase)
                    .foregroundStyle(.white)
                Spacer()

                bookmarkButton

                moreButton
            }
            .padding(.vertical, 5)
        }

    }

    private var image: some View {
        AsyncImage(url: look.imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxHeight: .infinity)

            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .onAppear {
                        print("Succesfully loaded image from: \(look.imageURL)")
                    }

            case .failure:
                        
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: .infinity)
                    .foregroundColor(.gray)
                    .onAppear {
                        if retryCount < 2 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            retryCount += 1
                                            print("retryCount working \(retryCount)")
                                        }
                                    }
                        print("Failed to load image from: \(look.imageURL)")
                    }

            @unknown default:
                EmptyView()
            }
        }
        .id(retryCount)
    }

    private var bookmarkButton: some View {
        Button(action: onBookmarkToggle) {
                    Image(systemName: look.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(.gray)
                        .font(.system(size: 24))
                        .padding(.trailing, 5)
                }
    }

    private var moreButton: some View {
        Menu {
            Button("Option 1", action: { print("Option 1 selected") })
            Button("Option 2", action: { print("Option 2 selected") })
            Button("Option 3", action: { print("Option 3 selected") })
        } label: {
            Image(systemName: "ellipsis")
                .rotationEffect(Angle(degrees: 90))
                .foregroundStyle(.white)
                .font(.system(size: 20))
                .padding(.trailing, 5)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        SingleLookView(
            look: Look.preview,
            lookNumber: 1,
            totalNumberOfLooks: 40, onBookmarkToggle: {}
        )
    }

}
