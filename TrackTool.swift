//
//  TrackTool.swift
//  SwiftMusic
//
//  Created by K2 on 19/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit
import MediaPlayer

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
    }
    
    func pauseTrack() -> () {
        trackPlayer?.pause()
    }
    
    func nextTrack() {
        trackIndex += 1
        let track = tracks[trackIndex]
        playTrack(track: track)
    }
    
}
