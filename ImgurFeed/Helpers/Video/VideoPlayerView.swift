//
//  VideoPlayerView.swift
//  ImgurFeed
//
//  Created by Senthil on 21/03/2025.
//

import SwiftUI

struct VideoPlayerView: UIViewRepresentable {
    
    // MARK: - Properties
    
    var videoUrl: URL // The URL of the video to play
    var thumbnailUrl: URL? // The URL of the thumbnail image for the video
    @Binding var state: VideoPlayerState // Binding to track the video player's state (muted, playing, loaded)
    
    // MARK: - Coordinator
    
    /// Creates a coordinator to manage state changes and interactions.
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - UIViewRepresentable Methods
    
    /// Creates the `VideoPlayer` UIView and configures it with the video and thumbnail.
    func makeUIView(context: Context) -> VideoPlayer {
        let videoPlayer = VideoPlayer()
        
        // Load the thumbnail if a URL is provided
        videoPlayer.loadThumbnail(url: thumbnailUrl)
        
        // Load the video if it is marked as loaded in the state
        if state.isLoaded {
            videoPlayer.loadVideo(videoUrl, isMute: state.isMuted, canPlay: state.isPlaying)
        }
        
        // Store the initial state values in the coordinator
        context.coordinator.previousMuted = state.isMuted
        context.coordinator.previousPlaying = state.isPlaying
        context.coordinator.previousLoaded = state.isLoaded
        
        return videoPlayer
    }
    
    /// Updates the `VideoPlayer` UIView based on changes to the state.
    func updateUIView(_ uiView: VideoPlayer, context: Context) {
        let coordinator = context.coordinator
        
        // Load or unload the video if the `isLoaded` state changes
        if state.isLoaded != coordinator.previousLoaded {
            if state.isLoaded {
                uiView.loadVideo(videoUrl, isMute: state.isMuted)
            } else {
                uiView.cleanUpPlayer()
            }
            coordinator.previousLoaded = state.isLoaded
        }
        
        // Toggle mute state if it changes
        if state.isMuted != coordinator.previousMuted {
            uiView.toggleSound(state.isMuted)
            coordinator.previousMuted = state.isMuted
        }
        
        // Play or pause the video if the `isPlaying` state changes
        if state.isPlaying != coordinator.previousPlaying {
            uiView.playVideo(state.isPlaying)
            coordinator.previousPlaying = state.isPlaying
        }
    }
    
    // MARK: - Coordinator Class
    
    /// Manages the previous state values to detect changes and avoid unnecessary updates.
    class Coordinator {
        var previousMuted: Bool = false // Tracks the previous mute state
        var previousPlaying: Bool = false // Tracks the previous play state
        var previousLoaded: Bool = false // Tracks the previous loaded state
    }
}
