//
//  Post.swift
//  ImgurFeed
//
//  Created by Senthil on 19/03/2025.
//

import Foundation

// MARK: - Gallery Structure

/// Represents a gallery item, which can be either an image or a video.
struct Gallery: Codable, Identifiable {
    
    // MARK: - Properties
    
    let id: String // Unique identifier for the gallery item
    
    private let type: String // MIME type of the gallery item (e.g., "image/jpeg", "video/mp4")
    let url: URL // URL to the gallery item's content
    
    // MARK: - CodingKeys
    
    /// Maps the JSON keys to the struct properties.
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case url = "link" // Maps the JSON key "link" to the `url` property
    }
    
    // MARK: - Initializer for Decoding
    
    /// Custom initializer for decoding from JSON.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        
        type = try container.decode(String.self, forKey: .type)

        url = try container.decode(URL.self, forKey: .url)
    }
    
    // MARK: - Encoding
    
    /// Custom method for encoding to JSON.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        
        try container.encode(type, forKey: .type)
        
        try container.encode(url, forKey: .url)
    }
    
    // MARK: - Computed Properties
    
    /// Determines the type of the gallery item (image or video) based on the `type` property.
    var galleryType: GalleryType {
        if type.contains("image/") {
            return .image
        } else {
            return .video
        }
    }
    
    /// Returns a thumbnail URL for video gallery items. For images, returns `nil`.
    var thumbnailUrl: URL? {
        if galleryType == .video {
            // Construct a thumbnail URL for videos using the `id`.
            return URL(string: "https://i.imgur.com/\(id).jpg")
        }
        return nil
    }
}

// MARK: - GalleryType Enum

/// Represents the type of a gallery item.
enum GalleryType {
    case image
    case video
}
