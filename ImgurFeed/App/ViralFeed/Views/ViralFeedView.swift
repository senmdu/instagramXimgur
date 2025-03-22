//
//  HomeFeedView.swift
//  ImgurFeed
//
//  Created by Senthil on 19/03/2025.
//

import SwiftUI
import AVKit

struct ViralFeedView: View {
    
    @StateObject private var viewModel = ViralPostViewModel()
    @State private var hasFetchedData = false

    /// Body
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.viralPosts, id: \.id) { post in
                        ViralPostView(post: post)
                    }
                }
                .padding(.top, 12)
            }
            .navigationTitle("Viral Posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolBar
            }.refreshable {
               viewModel.fetchViralPosts()
            }.overlay {
                // Show a loader while loading
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }

                // Show an error message if there's an error
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                }
            }
        }.onAppear {
            // Fetch viral posts and update the loading state
            if !hasFetchedData {
                Task {
                    viewModel.fetchViralPosts()
                    hasFetchedData = true
                }
            }
        }
    }

    // toolbar
    private var toolBar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                Image("logo").resizable()
                    .frame(width: 80, height: 30)
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                    Image(systemName: "heart")
                        .imageScale(.large)
                    Image(systemName: "paperplane")
                        .imageScale(.large)
            }
        }
    }
}

#Preview {
    ViralFeedView()
}
