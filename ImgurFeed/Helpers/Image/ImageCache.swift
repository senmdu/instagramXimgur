//
//  ImageCache.swift
//  ImgurFeed
//
//  Created by Senthil on 21/03/2025.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // Create a dedicated directory for caching images
        let directories = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = directories[0].appendingPathComponent("ImageCache")
        
        // Create the directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func image(for url: URL) async -> UIImage? {
        let key = url.absoluteString
        let filePath = cacheDirectory.appendingPathComponent(key.sanitizedFileName())
        
        // Check memory cache first
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        // Check local disk cache
        if let localImage = loadImageFromDisk(at: filePath) {
            memoryCache.setObject(localImage, forKey: key as NSString)
            return localImage
        }
        
        // Download the image if not found in cache
        do {
            let image = try await downloadImage(from: url)
            memoryCache.setObject(image, forKey: key as NSString)
            try saveImageToDisk(image, at: filePath)
            return image
        } catch {
            print("Failed to download or save image: \(error)")
            return nil
        }
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from data"])
        }
        
        return image
    }
    
    private func loadImageFromDisk(at path: URL) -> UIImage? {
        guard fileManager.fileExists(atPath: path.path) else { return nil }
        return UIImage(contentsOfFile: path.path)
    }
    
    private func saveImageToDisk(_ image: UIImage, at path: URL) throws {
        if let data = image.pngData() {
            try data.write(to: path)
        } else if let data = image.jpegData(compressionQuality: 1.0) {
            try data.write(to: path)
        } else {
            throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
    }
}

// MARK: - Helper Extension

extension String {
    fileprivate func sanitizedFileName() -> String {
        // Replace invalid characters in the URL to create a valid filename
        let invalidCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>")
        return self.components(separatedBy: invalidCharacters).joined(separator: "_")
    }
}

