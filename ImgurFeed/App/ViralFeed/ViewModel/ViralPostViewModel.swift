//
//  ViralPostViewModel.swift
//  ImgurFeed
//
//  Created by Senthil on 22/03/2025.
//

import Foundation
import Combine

class ViralPostViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading: Bool = false // Tracks whether the data is being loaded
    @Published var errorMessage: String? = nil // Tracks any error messages that occur during the fetch process
    
    @Published var viralPosts: [ViralPost] = [] // Holds the list of viral posts fetched from the API
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>() // Stores the cancellable objects for Combine subscriptions
    
    // MARK: - Methods
    
    /// Fetches viral posts from the API and updates the state accordingly.
    func fetchViralPosts() {
        // Set loading state to true and clear any previous error messages
        isLoading = true
        errorMessage = nil
        
        // Call the API to fetch viral posts
        APIManager.shared.fetchViralPosts()
            .receive(on: RunLoop.main) // Ensure updates are received on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                // Set loading state to false once the request completes
                self?.isLoading = false
                
                // Handle the completion result (success or failure)
                switch completion {
                case .finished:
                    break // Do nothing on successful completion
                case .failure(let error):
                    // Update the error message and log the error
                    self?.errorMessage = error.localizedDescription
                    print("Error fetching viral posts: \(error)")
                }
            }, receiveValue: { [weak self] posts in
                // Update the viralPosts array with the fetched posts
                self?.viralPosts = posts
            })
            .store(in: &cancellables) // Store the cancellable to manage the subscription lifecycle
    }
}
