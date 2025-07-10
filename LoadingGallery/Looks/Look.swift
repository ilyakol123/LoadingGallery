//
//  Look.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import Foundation
import Observation
import UIKit

struct Look: Identifiable, Decodable, Equatable {
    let id: String
    let imageURL: URL
    var image: UIImage? = nil

    private enum CodingKeys: String, CodingKey {
        case id
        case urls
    }

    private enum UrlsKeys: String, CodingKey {
        case raw
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)

        let urlsContainer = try container.nestedContainer(
            keyedBy: UrlsKeys.self,
            forKey: .urls
        )
        let rawUrlString = try urlsContainer.decode(String.self, forKey: .raw)

        guard
            let url = URL(string: rawUrlString + "&w=240&h=450&fit=crop&dpr=2")
        else {
            throw DecodingError.dataCorruptedError(
                forKey: .raw,
                in: urlsContainer,
                debugDescription: "Invalid URL string."
            )
        }

        imageURL = url
    }

    init(id: String, imageURL: URL) {
        self.id = id
        self.imageURL = imageURL
    }

}

#if DEBUG
    extension Look {
        static let preview = Look(
            id: "1",
            imageURL: URL(
                string:
                    "https://images.unsplash.com/photo-1749740436817-60414cc23115?ixid=M3w3NzQ0MjF8MXwxfGFsbHwxfHx8fHx8fHwxNzUxODkwODcyfA&ixlib=rb-4.1.0"
            )!,
        )
    }
#endif
