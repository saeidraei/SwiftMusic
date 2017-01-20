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
    @IBOutlet weak var currentTrack: UILabel!
    @IBOutlet weak var currentArtist: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    var tracks = [Track]()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTracks()
        TrackTool.shareInstance.tracks = tracks
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Music"
        
        // If a station has been selected, create "Now Playing" button to get back to current station
        /*if !firstTime {
            createNowPlayingBarButton()
        }
        
        // If a track is playing, display title & artist information and animation
        if currentTrack != nil && currentTrack!.isPlaying {
            let title = currentStation!.stationName + ": " + currentTrack!.title + " - " + currentTrack!.artist + "..."
            stationNowPlayingButton.setTitle(title, for: .normal)
            nowPlayingAnimationImageView.startAnimating()
        } else {
            nowPlayingAnimationImageView.stopAnimating()
            nowPlayingAnimationImageView.image = UIImage(named: "NowPlayingBars")
        }*/
        
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
    
    // MARK: - ProgressView Setting
    func setupProgressView() {
        let track = TrackTool.shareInstance.getTrackMessage()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        //let progressValue = Float(track1.costTime / track1.totalTime)
        progressBar.setProgress(Float(track.currentTime / track.totalTime), animated: false)
    }
    
    func updateProgress() {
        let track = TrackTool.shareInstance.getTrackMessage()
        if track.isPlaying {
            progressBar.setProgress(Float(track.currentTime / track.totalTime), animated: true)
        }
    }
    
    // MARK: - IBActions
    @IBAction func playPause(_ sender: Any) {
        
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        TrackTool.shareInstance.nextTrack()
        updateTrackMessage()
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
        
        // The UISeachController is active
        /*if searchController.isActive {
            let station = searchedStations[indexPath.row]
            cell.configureStationCell(station: station)
            
            // The UISeachController is not active
        } else {
            let station = stations[indexPath.row]
            cell.configureStationCell(station: station)
        }*/
        return cell
    }
}

extension TrackListController {
    func updateTrackMessage() {
        let message = TrackTool.shareInstance.getTrackMessage()
        
        // Checking track model make sure is not empty
        guard  message.trackModel != nil else {
            return
        }
        
        currentTrack.text = message.trackModel?.title
        currentArtist.text = message.trackModel?.artist
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
    }
}
