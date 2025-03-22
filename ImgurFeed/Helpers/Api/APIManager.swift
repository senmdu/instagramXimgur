//
//  APIManager.swift
//  ImgurFeed
//
//  Created by Senthil on 22/03/2025.
//

import Foundation
import Combine


class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://api.imgur.com/3/gallery/hot/viral/1"
    private let clientID = "e245fdec8586635" // Replace with your Imgur Client ID
    
    private init() {}
    
    /// Fetch viral post api
    func fetchViralPosts() -> AnyPublisher<[ViralPost], Error> {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ImgurResponse.self, decoder: JSONDecoder())
            .map(\.data)
            .eraseToAnyPublisher()
    }
}

// Define the Imgur API response structure
struct ImgurResponse: Codable {
    let data: [ViralPost]
}
