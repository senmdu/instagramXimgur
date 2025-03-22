//
//  VideoPlayer.swift
//  ImgurFeed
//
//  Created by Senthil on 21/03/2025.
//

import UIKit
import AVKit

class VideoPlayer: UIView {
    
    private var playerLayer : AVPlayerLayer?
    private var player: AVPlayer?
    
    private var videoUrl: URL?
    var thumbnailUrl : URL?
    
    /// A progress view to show loading state.
    let progressView: UIActivityIndicatorView = {
           let progressView = UIActivityIndicatorView(style: .large)
           progressView.translatesAutoresizingMaskIntoConstraints = false
           progressView.color = .blue
           progressView.hidesWhenStopped = true
           return progressView
    }()
    /// A thumbnail image view to display before the video loads.
    let thumbnailView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.isHidden = true
        return imgView
    }()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(thumbnailView)
        addSubview(progressView)
        setUpConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    deinit {
        cleanUpPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up constraints for the progress view and thumbnail view.
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            thumbnailView.centerXAnchor.constraint(equalTo: centerXAnchor),
            thumbnailView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailView.widthAnchor.constraint(equalTo: widthAnchor),
            thumbnailView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    // Adding the thumbnail so we will not see blank when video player
    func loadThumbnail(url:URL?) {
        guard let imgUrl = url, self.thumbnailUrl == nil else { return }
        self.thumbnailUrl = imgUrl
        self.progressView.startAnimating()
        Task {
            if let image = await ImageCache.shared.image(for: imgUrl) {
                await MainActor.run {
                    self.thumbnailView.image = image
                    self.thumbnailView.isHidden = false
                    if self.progressView.isAnimating {
                        self.progressView.stopAnimating()
                    }
                }
            }
        }
    }
    
    /// Loads the video from the provided URL and configures the player.
    func loadVideo(_ url: URL, isMute:Bool, canPlay:Bool = false) {
        if videoUrl == url { return } // Prevent reinitialization if same video

        videoUrl = url
        player = AVPlayer(url: url)
        player?.isMuted = isMute
        player?.actionAtItemEnd = .none
        player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        if canPlay {
            player?.play()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer!)
    }
    
    /// Handles the video playback reaching the end.
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    /// Toggles the mute state of the player.
    func toggleSound(_ toggle: Bool) {
        player?.isMuted = toggle
    }
    /// Plays or pauses the video based on the toggle value.
    func playVideo(_ toggle: Bool) {
        toggle ? player?.play() : player?.pause()
    }
    /// Cleans up the player and removes observers.
    func cleanUpPlayer() {
        guard videoUrl != nil else { return }
        self.player?.pause()
        self.playerLayer?.removeFromSuperlayer()
        self.player = nil
        self.playerLayer?.player = nil
        self.videoUrl = nil
        self.playerLayer = nil
        NotificationCenter.default.removeObserver(self)
    }
}
