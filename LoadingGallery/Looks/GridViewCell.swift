//
//  GridViewCell.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 08.07.2025.
//

import SwiftUI

struct GridViewCell: View {
    let look: Look

    var body: some View {
        imageView
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
}

#Preview {
    GridViewCell(look: Look.preview)
}
