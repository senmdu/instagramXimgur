//
//  ImgurTabView.swift
//  ImgurFeed
//
//  Created by Senthil on 20/03/2025.
//

import SwiftUI

struct ImgurTabView: View {
    var body: some View {
        TabView {
            ViralFeedView()
                .tabItem { Image(systemName: "house") }
            
            EmptyView()
                .tabItem { Image(systemName: "magnifyingglass") }
            
            EmptyView()
                .tabItem { Image(systemName: "plus.square") }
            
            EmptyView()
                .tabItem { Image(systemName: "heart") }
            
            EmptyView()
                .tabItem { Image(systemName: "person") }
        }.tint(.black)
    }
}

struct EmptyView: View {
    var body: some View {
        Text("Coming soon!").font(.title)
    }
}

#Preview {
    ImgurTabView()
}
