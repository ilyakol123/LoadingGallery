//
//  Look.swift
//  LoadingGallery
//
//  Created by Илья Колесников on 24.06.2025.
//

import Foundation
import Observation

struct Look: Identifiable, Decodable {
    let id: Int
    let imageURL: URL
    var isBookmarked: Bool
    var collectionId: Int? = nil

    private enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case isBookmarked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        
///use this one if id coming as a string
//        let idString = try container.decode(String.self, forKey: .id)
//        guard let idInt = Int(idString) else {
//            throw DecodingError.dataCorruptedError(
//                forKey: .id,
//                in: container,
//                debugDescription: "Expected string that can be converted to Int"
//            )
//        }

        id = try container.decode(Int.self, forKey: .id)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
        isBookmarked = try container.decode(Bool.self, forKey: .isBookmarked)
    }
    
    init(id: Int, imageURL: URL, isBookmarked: Bool, collectionId: Int? = nil) {
            self.id = id
            self.imageURL = imageURL
            self.isBookmarked = isBookmarked
            self.collectionId = collectionId
        }
    
}

#if DEBUG
extension Look {
    static let preview = Look(
        id: 1,
        imageURL: URL(string: "https://i.postimg.cc/4x0CMGsn/temp-Image0wga0r.avif")!,
        isBookmarked: false
    )
}
#endif




