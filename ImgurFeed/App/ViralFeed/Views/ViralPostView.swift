//
//  HomeFeedCell.swift
//  ImgurFeed
//
//  Created by Senthil on 19/03/2025.
//

import SwiftUI

struct ViralPostView: View {
    
    @State var post: ViralPost
    
    @State private var visibilityState: [String: Bool] = [:] // Track visibility for each tab
    
    @State private var canPlayVideoState: [String: Bool] = [:] // Track playback state for each tab
    
    @State private var selectedTab: Int = 0
    
    @State private var avatar: UIImage? = nil
    
    var body: some View {
        VStack {
            // Profile image & username
            profileHeader
            // Post
            postCarousel
            // Action Buttons, Likes, Caption, and Time
            postFooter
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        HStack {
            if let avatar = avatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
            }
            Text(post.accountUrl)
                .font(.footnote).fontWeight(.semibold)
            Spacer()
            Button {} label: {
                Image(systemName: "ellipsis")
                    .imageScale(.large)
            }.foregroundColor(.primary)
        }.onAppear {
            Task {
                if let avatar = post.avatar {
                    self.avatar = await ImageCache.shared.image(for: avatar)
                }
            }
        }
        .padding(.leading, 6)
        .padding(.trailing, 8)
    }
    
    // MARK: - Post Carousel
      private var postCarousel: some View {
          GeometryReader { geometry in
              let frame = geometry.frame(in: .global)
              let screenHeight = UIScreen.main.bounds.height
              let isCellVisibleOnScreen = frame.midY > screenHeight * 0.3 && frame.midY < screenHeight * 0.7
              
              if let gallery = post.gallery {
                  TabView(selection: $selectedTab) {
                      ForEach(gallery.indices, id: \.self) { index in
                          GalleryView(
                            gallery: gallery[index],
                            isVisible: Binding(
                                get: { visibilityState[post.gallery![index].id] ?? false },
                                set: { visibilityState[post.gallery![index].id] = $0 }
                            ),
                            canPlayVideo: Binding(
                                get: { canPlayVideoState[post.gallery![index].id] ?? false },
                                set: { canPlayVideoState[post.gallery![index].id] = $0 }
                            )
                          )
                          .tag(index)
                      }
                  }.tabViewStyle(.page(indexDisplayMode: .automatic))
                  .onChange(of: isCellVisibleOnScreen, { oldValue, newValue in
                      canPlayVideoState[post.gallery![selectedTab].id] = newValue
                  })
                  .onChange(of: selectedTab, { oldValue, newValue in
                      canPlayVideoState[post.gallery![oldValue].id] = false
                      if isCellVisibleOnScreen {
                          canPlayVideoState[post.gallery![newValue].id] = true
                      }
                  }).onAppear {
                      if isCellVisibleOnScreen {
                          canPlayVideoState[post.gallery![selectedTab].id] = true
                      }
                      post.gallery?.forEach { gallery in
                         visibilityState[gallery.id] = true
                      }
                  }
                  .onDisappear {
                      post.gallery?.forEach { gallery in
                         canPlayVideoState[gallery.id] = false
                         visibilityState[gallery.id] = false
                      }
                  }
              }else {
                  Text("No Post available")
              }
          }.frame(width: 400, height: 400).clipShape(Rectangle())
    }
    
    // MARK: - Post Footer (Action Buttons, Likes, Caption, Time)
    private var postFooter: some View {
        VStack {
            // Action Buttons
            actionButtons
            // Likes
            likesSection
            // Caption
            captionSection
            // Time
            timeSection
        }
        .padding(.leading, 12)
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack {
            HStack(spacing:1) {
                Button {} label: { Image(systemName: "arrowshape.up")
                    .imageScale(.large)
                }
                if post.ups > 0 {
                    Text("\(post.ups)")
                }
            }
            
            HStack(spacing:1) {
                Button {} label: { Image(systemName: "arrowshape.down")
                    .imageScale(.large)
                }
                if post.downs > 0 {
                    Text("\(post.downs)")
                }
            }
            
            HStack(spacing:1) {
                Button {} label: { Image(systemName: "bubble.right")
                        .imageScale(.large)
                }
                if post.commentCount > 0 {
                    Text("\(post.commentCount)")
                }
            }
           
            Button {} label: {
                Image(systemName: "paperplane")
                    .imageScale(.large)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "bookmark")
                    .imageScale(.large)
            }
        }
        .padding(.top, 4)
        .padding(.leading, -6)
        .padding(.trailing, 8)
        .foregroundColor(.primary)
    }
    
    // MARK: - Likes Section
    private var likesSection: some View {
        Text("\(post.views) Views")
            .font(.footnote)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 1)
    }
    
    // MARK: - Caption Section
    private var captionSection: some View {
        HStack {
            Text("\(post.accountUrl) ").fontWeight(.semibold) +
            Text("\(post.caption ?? "")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.footnote)
    }
    
    // MARK: - Time Section
    private var timeSection: some View {
        Text(self.post.date.formattedDate())
            .font(.footnote)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 1)
    }
}
