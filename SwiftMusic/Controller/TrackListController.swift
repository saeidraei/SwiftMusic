//
//  TrackListController.swift
//  SwiftMusic
//
//  Created by K2 on 19/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit
import AVFoundation

class TrackListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var currentTrack: MarqueeLabel!
    @IBOutlet weak var currentArtist: MarqueeLabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nowPlayingView: UIView!
    var firstTime = true
    var nowPlaying : CADisplayLink?
    var tracks = [Track]()
    var timer = Timer()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingView.isHidden = true
        loadTracks()
        TrackTool.shareInstance.tracks = tracks
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Music"
        setupUILabelScrolling()
        
        // Auto play next track when current track is finish
        NotificationCenter.default.addObserver(self, selector: #selector(nextTrack(_:)), name: NSNotification.Name(rawValue: trackFinish), object: nil)
        
        if !firstTime {
            updateTrackMessage()
            setupProgressView()
            TrackTool.shareInstance.setButtonImage(button: playPauseBtn)
            
            let track = TrackTool.shareInstance.getTrackMessage()
            if track.isPlaying {
                startProgressTimer()
            }
        }
    }
    
    // MARK - UI Element
    func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName:UIColor.white])
        self.refreshControl.backgroundColor = UIColor.black
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.addTarget(self, action: #selector(TrackListController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    // MARK: - Actions
    func refresh(sender: AnyObject) {
        // Pull to Refresh
        tracks.removeAll(keepingCapacity: false)
        loadTracks()
        
        // Refresh Timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        }
    }
    
    // MARK: - LoadTrackData
    func loadTracks() {
        TrackModel.getTracks { (tracksData : [Track]) in
            //print(tracksData)
            print("LoadTrack")
            for track in tracksData {
                self.tracks.append(track)
                //let t = tracksData[2]
                //print("Name: \(t.title), Artist: \(t.artist)")
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.view.setNeedsDisplay()
            })
        }
    }
    
    // MARK: - Setup ProgressView
    
    func setupProgressView() {
        let track = TrackTool.shareInstance.getTrackMessage()
        progressBar.setProgress(Float(track.currentTime / track.totalTime), animated: false)
    }
    
    func startProgressTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            
            let track = TrackTool.shareInstance.getTrackMessage()
            print("Main Timer!")
            if track.isPlaying {
                print(track.currentTime, track.totalTime)
                self.progressBar.setProgress(Float(track.currentTime / track.totalTime), animated: true)
            } else {
                return
            }
        }
    }
    
    func updateProgress() {
        let track = TrackTool.shareInstance.getTrackMessage()
        if track.isPlaying {
            progressBar.setProgress(Float(track.currentTime / track.totalTime), animated: true)
        }
    }
    
    func setupUILabelScrolling() {
        // Setup auto scrolling for UILabel
        currentTrack.type = .continuous
        currentTrack.speed = .duration(12.0)
        currentTrack.fadeLength = 18.0
        
        currentArtist.type = .continuous
        currentArtist.speed = .duration(12.0)
        currentArtist.fadeLength = 18.0
    }
    
    // MARK: - IBActions
    @IBAction func playPause(_ sender: Any) {
        let track = TrackTool.shareInstance.getTrackMessage()
        
        if track.isPlaying {
            playPauseBtn.setImage(UIImage(named: "playbtn"), for: .normal)
            TrackTool.shareInstance.pauseTrack()
            timer.invalidate()
        } else {
            playPauseBtn.setImage(UIImage(named: "pausebtn"), for: .normal)
            TrackTool.shareInstance.playCurrnetTrack()
            setupProgressView()
            startProgressTimer()
        }
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        playPauseBtn.setImage(UIImage(named: "pausebtn"), for: .normal)
        TrackTool.shareInstance.nextTrack()
        updateTrackMessage()
        setupProgressView()
        startProgressTimer()
    }
    
    @IBAction func showPopUp(_ sender: Any) {
        timer.invalidate()
        
        NotificationCenter.default.removeObserver(self)
        
        self.performSegue(withIdentifier: "NowPlaying", sender: nil)
    }
}

// MARK: - TableViewDataSource
extension TrackListController: UITableViewDataSource {
    @objc(tableView:heightForRowAtIndexPath:)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TracksListCell
        
        // Configure the cell...
        let track = tracks[indexPath.row]
        cell.configureTrackCell(track: track)
        return cell
    }
}

extension TrackListController {
    func updateTrackMessage() {
        let message = TrackTool.shareInstance.getTrackMessage()
        
        // Checking track model make sure is not empty
        guard message.trackModel != nil else {
            return
        }
        
        currentTrack.text = message.trackModel?.title
        currentArtist.text = message.trackModel?.artist
        
        if message.trackModel?.artwork == nil{
            currentImage.image = UIImage(named: "artwork")
        } else {
            currentImage.image = UIImage(data: (message.trackModel?.artwork)!)
        }
        
    }
}

// MARK: - TableViewDelegate
extension TrackListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let track = tracks[indexPath.row]
        TrackTool.shareInstance.playTrack(track: track)
        updateTrackMessage()
        setupProgressView()
        
        if firstTime {
            UIView.animate(withDuration: 1.0, animations: {
                self.nowPlayingView.isHidden = false
                self.nowPlayingView.center.x += self.view.bounds.width
                self.firstTime = false
                print("NX", self.nowPlayingView.center.x)
                self.startProgressTimer()
            })
        }
    }
}

extension TrackListController {
    override func remoteControlReceived(with event: UIEvent?) {
        
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
            //timer.invalidate()
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
        updateTrackMessage()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        TrackTool.shareInstance.nextTrack()
        updateTrackMessage()
    }
}


