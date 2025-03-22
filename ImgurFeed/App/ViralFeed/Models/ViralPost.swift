//
//  Post.swift
//  ImgurFeed
//
//  Created by Senthil on 21/03/2025.
//

import Foundation

// MARK: - ViralPost Structure

/// Represents a viral post containing details like upvotes, downvotes, comments, views, and associated gallery items.
struct ViralPost: Codable, Identifiable {
    
    // MARK: - Properties
    
    let id: String // Unique identifier for the post
    let accountUrl: String // URL or identifier for the user's account
    let ups: Int // Number of upvotes the post has received
    let downs: Int // Number of downvotes the post has received
    let commentCount: Int // Number of comments on the post
    let views: Int // Number of views the post has received
    let caption: String? // Optional caption or title for the post
    let gallery: [Gallery]? // Optional array of gallery items (images or videos) associated with the post
    let date: Date // Timestamp of when the post was created
    
    // MARK: - Computed Properties
    
    /// Returns the URL for the user's avatar based on their `accountUrl`.
    var avatar: URL? {
        return URL(string: "https://imgur.com/user/\(accountUrl)/avatar")
    }
    
    // MARK: - CodingKeys
    
    /// Maps the JSON keys to the struct properties.
    enum CodingKeys: String, CodingKey {
        case id
        case accountUrl = "account_url"
        case ups
        case downs
        case commentCount = "comment_count"
        case views
        case caption = "title"
        case gallery = "images"
        case date = "datetime"
    }
    
    // MARK: - Initializer for Decoding
    
    /// Custom initializer for decoding from JSON.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        accountUrl = try container.decode(String.self, forKey: .accountUrl)
        
        ups = try container.decodeIfPresent(Int.self, forKey: .ups) ?? 0
        
        downs = try container.decodeIfPresent(Int.self, forKey: .downs) ?? 0
        
        commentCount = try container.decodeIfPresent(Int.self, forKey: .commentCount) ?? 0
        views = try container.decodeIfPresent(Int.self, forKey: .views) ?? 0
        
        caption = try container.decodeIfPresent(String.self, forKey: .caption)
        
        gallery = try container.decodeIfPresent([Gallery].self, forKey: .gallery)
        
        let timestampMillis = try container.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestampMillis)
    }
    
    // MARK: - Encoding
    
    /// Custom method for encoding to JSON.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)

        try container.encode(accountUrl, forKey: .accountUrl)

        try container.encode(ups, forKey: .ups)
        
        try container.encode(downs, forKey: .downs)
        
        try container.encode(commentCount, forKey: .commentCount)
        
        try container.encode(views, forKey: .views)
        
        try container.encodeIfPresent(caption, forKey: .caption)
        
        try container.encodeIfPresent(gallery, forKey: .gallery)
        
        try container.encode(date.timeIntervalSince1970, forKey: .date)
    }
}
