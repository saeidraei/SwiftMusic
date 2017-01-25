//
//  TrackTool.swift
//  SwiftMusic
//
//  Created by K2 on 19/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit
import MediaPlayer

let trackFinish = "trackFinish"

class TrackTool: NSObject , AVAudioPlayerDelegate{
    var trackPlayer: AVAudioPlayer?
    static let shareInstance = TrackTool()
    var track: TrackMessage = TrackMessage()
    var tracks: [Track] = [Track]()
    var trackIndex = -1 {
        didSet {
            if trackIndex < 0 {
                trackIndex = tracks.count - 1
            }
            if trackIndex > tracks.count - 1 {
                trackIndex = 0
            }
        }
    }
    
    override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
            try session.setActive(true)
        } catch {
            print(error)
            return
        }
    }
    
    func getTrackMessage() -> TrackMessage {
        track.trackModel = tracks[trackIndex]
        track.currentTime = (trackPlayer?.currentTime) ?? 0
        track.totalTime = (trackPlayer?.duration) ?? 0
        track.isPlaying = (trackPlayer?.isPlaying) ?? false
        return track
    }
    
    // MARK - Track Tools
    func playTrack(track : Track) {
        guard let path = Bundle.main.url(forResource: track.fileName, withExtension: nil) else {
            return
        }
        
        trackIndex = tracks.index(of: track)!
        // Skip if the track is playing
        if trackPlayer?.url == path {
            trackPlayer?.play()
            
            return
        }
        //2 根据路径创建播放器 因为AVAudioPlayer 需要thorw 穿透
        do {
            trackPlayer = try AVAudioPlayer(contentsOf: path)
            trackPlayer?.delegate = self
        } catch {
            print(error)
            return
        }

        trackPlayer?.prepareToPlay()
        trackPlayer?.play()
        setupLockScreen()
    }
    
    func playCurrnetTrack () {
        let track = tracks[trackIndex]
        playTrack(track: track)
        setupLockScreen()
    }
    
    func pauseTrack() -> () {
        trackPlayer?.pause()
        setupLockScreen()
    }
    
    func nextTrack() {
        trackIndex += 1
        let track = tracks[trackIndex]
        playTrack(track: track)
        setupLockScreen()
    }
    
    func previousTrack() {
        trackIndex -= 1
        let track = tracks[trackIndex]
        playTrack(track: track)
        setupLockScreen()
    }
    
    func setProgress(currentProgress : CGFloat) {
        let progress = (trackPlayer?.currentTime)! / (trackPlayer?.duration)!
        
        if CGFloat(progress) == currentProgress {
            return
        }
        let duration = trackPlayer?.duration
        trackPlayer?.currentTime = TimeInterval(currentProgress) * duration!
        setupLockScreen()
    }
    
    func setButtonImage(button: UIButton) {
        //let track = TrackTool.shareInstance.getTrackMessage()
        
        if track.isPlaying {
            return button.setImage(UIImage(named: "pausebtn"), for: .normal)
        } else {
           return button.setImage(UIImage(named: "playbtn"), for: .normal)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: trackFinish), object: self, userInfo: nil)
    }
}

extension TrackTool {
    func setupLockScreen() {
        let lockMsg = getTrackMessage()
        let centerInfo = MPNowPlayingInfoCenter.default()
        
        let title = lockMsg.trackModel?.title ?? ""
        let artist = lockMsg.trackModel?.artist ?? ""
        var image: UIImage
        
        if lockMsg.trackModel?.artwork == nil {
            image = UIImage(named: "artwork")!
        } else {
            image = UIImage(data: (lockMsg.trackModel?.artwork)!)!
        }
        
        let artwork = MPMediaItemArtwork.init(boundsSize: (image.size), requestHandler: { (size) -> UIImage in
            return image
        })
        let currentTime = lockMsg.currentTime
        let totalTime = lockMsg.totalTime
        
        var playRate: NSNumber = 0
        
        if lockMsg.isPlaying {
            playRate = 1.0
        }
        
        centerInfo.nowPlayingInfo = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: artist,
            MPMediaItemPropertyArtwork: artwork,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: totalTime,
            MPNowPlayingInfoPropertyPlaybackRate: playRate
        ]

        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
}
