//
//  PostView.swift
//  ImgurFeed
//
//  Created by Senthil on 19/03/2025.
//

import SwiftUI

struct GalleryView: View {
    
    @State private var image: UIImage? = nil
    
    let gallery: Gallery
    
    @Binding var isVisible : Bool
    
    @Binding var canPlayVideo : Bool
    
    @State private var videoState = VideoPlayerState(isMuted: false, isPlaying: false, isLoaded: false)
    
    var body: some View {
        if gallery.galleryType == .image {
            imageView
        } else {
           videoView
        }
    }
    /// Displays the image for image gallery items.
    var imageView : some View {
        
        ZStack {
            if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
            } else {
                ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            }
        }.onAppear {
            Task {
                image = await ImageCache.shared.image(for: gallery.url)
            }
        }
    }
    /// Displays the video player for video gallery items.
    var videoView : some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayerView(videoUrl: gallery.url, thumbnailUrl:gallery.thumbnailUrl, state: $videoState)
            muteButton
        }.onChange(of: isVisible) { oldValue, newValue in
            videoState.isLoaded = newValue
        }.onChange(of: canPlayVideo, { oldValue, newValue in
            videoState.isPlaying = newValue
        })
    }
    /// A button to toggle the mute state of the video player.
    var muteButton : some View {
        Button(action: {
            videoState.isMuted.toggle()
        }) {
            Image(systemName: videoState.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .padding(.top, 15)
        .padding(.trailing, 15)
    }
}
