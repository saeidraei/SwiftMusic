//
//  PopUpController.swift
//  SwiftMusic
//
//  Created by K2 on 21/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit

class PopUpController: UIViewController {
    @IBOutlet weak var trackTitle: MarqueeLabel!
    @IBOutlet weak var artist: MarqueeLabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playPauseBtn: UIButton!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("POPUP Did LOAD")
        setupTrackDetails()
        TrackTool.shareInstance.setButtonImage(button: playPauseBtn)
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPause(_ sender: Any) {
        let track = TrackTool.shareInstance.getTrackMessage()
        
        if track.isPlaying {
            //self.pauseForeImageViewAnimation()
            playPauseBtn.setImage(UIImage(named: "playbtn"), for: .normal)
            TrackTool.shareInstance.pauseTrack()
            timer.invalidate()
            //nowPlaying?.isPaused = true
        } else {
            //self.resumeForeImageViewAnimation()
            playPauseBtn.setImage(UIImage(named: "pausebtn"), for: .normal)
            TrackTool.shareInstance.playCurrnetTrack()
            setupProgressSlider()
            //nowPlaying?.isPaused = false
        }

    }
    
    @IBAction func changeProgressValue(_ sender: UISlider) {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        progressSlider.value = sender.value
        print("VALUE: \(progressSlider.value)")
        TrackTool.shareInstance.setProgress(currentProgress: CGFloat(self.progressSlider.value))
    }
    
    
    @IBAction func nextTrack(_ sender: Any) {
        playPauseBtn.setImage(UIImage(named: "pausebtn"), for: .normal)
        TrackTool.shareInstance.nextTrack()
        setupTrackDetails()
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        playPauseBtn.setImage(UIImage(named: "pausebtn"), for: .normal)
        TrackTool.shareInstance.previousTrack()
        setupTrackDetails()
    }
    
    // MARK: - Setup Progress Slider
    func setupProgressSlider() {
        let track = TrackTool.shareInstance.getTrackMessage()
        progressSlider.value = Float(track.currentTime / track.totalTime)
        currentTime.text = TimeFormat.getFormatTime(timerInval: track.currentTime)
        finishTime.text = "-\(TimeFormat.getFormatTime(timerInval: (track.totalTime - track.currentTime)))"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            
            print("isPlaying \(track.isPlaying)")
            if track.isPlaying {
                self.progressSlider.value = Float(track.currentTime / track.totalTime)
                self.currentTime.text = TimeFormat.getFormatTime(timerInval: track.currentTime)
                self.finishTime.text = "-\(TimeFormat.getFormatTime(timerInval: (track.totalTime - track.currentTime)))"
            } else {
                return
            }
        }
    }
    
    // MARK: - Setup track detail
    func setupTrackDetails() {
        let message = TrackTool.shareInstance.getTrackMessage()
        
        guard message.trackModel != nil else{
            return
        }
        
        trackTitle.text = message.trackModel?.title
        trackTitle.type = .continuous
        trackTitle.speed = .duration(12.0)
        trackTitle.fadeLength = 15.0
        
        artist.text = message.trackModel?.artist
        artist.type = .continuous
        artist.speed = .duration(12.0)
        artist.fadeLength = 15.0
        
        setupProgressSlider()
    }
}
