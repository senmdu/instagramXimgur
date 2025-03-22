# InstagramXImgur

**InstagramXImgur** is a lightweight Instagram-like app built using **SwiftUI** and the **MVVM** architecture. It fetches viral posts from the **Imgur API** and displays them in a scrollable feed, supporting both images and videos. This app demonstrates the potential of SwiftUI and Combine in building clean, responsive, and scalable mobile applications.

---

# Demo
<div align="left">
  <img src="ReadMe/instagramXimgur%20Demo%201.png" width="200" />
  <img src="ReadMe/instagramXimgur%20Demo%202.png" width="200" />
  <img src="ReadMe/instagramXimgur%20Demo%203.png" width="200" />
  <img src="ReadMe/instagramXimgur%20Demo%204.png" width="200" />
</div>

---

## Features

✅ **Viral Feed**: Scrollable feed of viral posts with user profile pictures, captions, upvotes, downvotes, comment counts, and timestamps.

✅ **Image and Video Support**: Displays images and videos in the feed.

✅ **Autoplay**: Videos autoplay when visible and pause when scrolled away.

✅ **Memory Management**: Removes `AVPlayer` when videos are not visible to optimize memory usage.

✅ **Dark Mode**

✅ **Unit Tests**

---

## Tech Stack

- **SwiftUI**
- **MVVM Architecture**
- **Imgur API**
- **Combine Framework**
- **AVFoundation**

---

## Code Structure

- **Models**: `ViralPost`, `Gallery`.
- **Views**: `ViralFeedView`, `ViralPostView`, `GalleryView`, `VideoPlayerView`.
- **ViewModels**: `ViralPostViewModel`.
- **Utilities**: `APIManager`, `ImageCache`.

---

## Setup

1. Clone the repository.
2. Add your Imgur API client ID in `APIManager.swift`.
3. Build and run the app.

---

## ToDo 🔜

- Pagination for infinite scrolling.
- Explore Feed.
- Image & video detail view
- Profile
- Offline support.

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

Enjoy **InstagramXImgur**! 🚀
