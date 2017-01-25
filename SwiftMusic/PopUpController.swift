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
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playPauseBtn: UIButton!
    var popupTimer = Timer()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("POPUP Did LOAD")
        setupTrackDetails()
        progressTimer()
        setupProgressSlider()
        TrackTool.shareInstance.setButtonImage(button: playPauseBtn)
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nextTrack(_:)), name: NSNotification.Name(rawValue: trackFinish), object: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    // MARK: - IBActions
    @IBAction func closeButtonPressed(_ sender: Any) {
        print("Closed!!")
        popupTimer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPause(_ sender: Any) {
        let track = TrackTool.shareInstance.getTrackMessage()
        
        if track.isPlaying {
            //self.pauseForeImageViewAnimation()
            playPauseBtn.setImage(UIImage(named: "playbtn"), for: .normal)
            //popupTimer.invalidate()
            TrackTool.shareInstance.pauseTrack()
            //nowPlaying?.isPaused = true
        } else {
            //self.resumeForeImageViewAnimation()
            playPauseBtn.setImage(UIImage(named: "pausebtn"), for: .normal)
            TrackTool.shareInstance.playCurrnetTrack()
            //nowPlaying?.isPaused = false
        }

    }
    
    @IBAction func changeProgressValue(_ sender: UISlider) {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        //if currentTrack.isPlaying {
            progressSlider.value = sender.value
            print("VALUE: \(progressSlider.value)")
            TrackTool.shareInstance.setProgress(currentProgress: CGFloat(self.progressSlider.value))
        //}
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
    }
    
    func progressTimer() {
        popupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            let track = TrackTool.shareInstance.getTrackMessage()
            let status = UIApplication.shared.applicationState
            if status == .background {
                
            }
            print("Detail Timer!")
            if track.isPlaying {
                print(track.currentTime, track.totalTime)
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
        let track = TrackTool.shareInstance.getTrackMessage()
        
        guard track.trackModel != nil else{
            return
        }
        
        trackTitle.text = track.trackModel?.title
        trackTitle.type = .continuous
        trackTitle.speed = .duration(12.0)
        trackTitle.fadeLength = 15.0
        
        artist.text = track.trackModel?.artist
        artist.type = .continuous
        artist.speed = .duration(12.0)
        artist.fadeLength = 15.0
        
        if track.trackModel?.artwork == nil {
            trackImage.image = UIImage(named: "artwork")
        } else {
            trackImage.image = UIImage(data: (track.trackModel?.artwork)!)
        }
        
    }
}

extension PopUpController {
    override func remoteControlReceived(with event: UIEvent?) {
        //let type = event?.subtype
        
        guard let event = event else {
            print("No event")
            return
        }
        
        guard event.type == UIEventType.remoteControl else {
            print("Received other control type")
            return
        }
        
        switch event.subtype {
        case UIEventSubtype.remoteControlPlay:
            print("play")
            TrackTool.shareInstance.playCurrnetTrack()
        case UIEventSubtype.remoteControlPause:
            TrackTool.shareInstance.pauseTrack()
            print("pause")
        case UIEventSubtype.remoteControlNextTrack:
            TrackTool.shareInstance.nextTrack()
            print("next")
        case UIEventSubtype.remoteControlPreviousTrack:
            TrackTool.shareInstance.previousTrack()
            print("previous")
        default:
            print("")
        }
        setupTrackDetails()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        TrackTool.shareInstance.nextTrack()
        setupTrackDetails()
    }
}

