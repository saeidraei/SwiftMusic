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
    
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTracks()
        
        //let doc = Bundle.main.resourcePath!
        //let fileManager = FileManager.default
        
        
        /*do {
            print("Load Data")
            let fileFromBundle = try fileManager.contentsOfDirectory(atPath: doc).filter{$0.contains(".mp3")}
            print("File: \(fileFromBundle)")
            
            /*let file = Bundle.main.resourceURL!
             let fileURL = try fileManager.contentsOfDirectory(at: file, includingPropertiesForKeys: nil, options: []).filter{$0.pathExtension == "mp3"}
             print(fileURL)*/
            
            
            var tracks = [Track]()
            var title:String = ""
            var artist:String = ""
            
            for path in fileFromBundle {
                print("1")
                let audioPath = Bundle.main.url(forResource: path, withExtension: nil)
                let playerItem = AVPlayerItem(url: audioPath!)
                let metadataList = playerItem.asset.metadata
                print("2 \(audioPath)")
                for item in metadataList {
                    
                    if item.commonKey == nil {
                        continue
                    }
                    
                    if let key = item.commonKey, let value = item.value {
                        if key == "title" {
                            title = value as! String
                            print("title: \(title)")
                        }
                        if key == "artist" {
                            artist = value as! String
                            print("artist: \(artist)")
                        }
                    }
                }
                let track = Track(title: title, artist: artist)
                tracks.append(track)
            }
            print("Tracks: \(tracks.count)")
        } catch let error{
            print(error)
        }*/
    
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
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
}

extension TrackListController: UITableViewDataSource {
    @objc(tableView:heightForRowAtIndexPath:)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // The UISeachController is active
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tracks.isEmpty{
            print("EMPTY")
        }
        print("NOT EMPTY")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TracksListCell
        
        // alternate background color
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        
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
        print("Cell")
        return cell
    }
}
