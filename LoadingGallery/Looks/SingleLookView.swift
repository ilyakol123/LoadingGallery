//
//  ImageView.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import SwiftUI

struct SingleLookView: View {
    let look: Look
    
    @State private var isBookmarked: Bool = false

    var body: some View {
        VStack {
            imageView
            actionsRow
        }

    }

    @ViewBuilder
    private var imageView: some View {
        if let uiImage = look.image {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
        }
    }
    
    private var actionsRow: some View {
        HStack {
            Spacer()

            bookmarkButton

            moreButton
        }
        .padding(.vertical, 5)
    }

    private var bookmarkButton: some View {
        Button {
            isBookmarked.toggle()
        } label: {
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
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
            look: Look.preview
        )
    }

}
