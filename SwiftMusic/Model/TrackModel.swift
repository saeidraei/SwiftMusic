//
//  TrackModel.swift
//  SwiftMusic
//
//  Created by K2 on 19/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit
import AVFoundation

class TrackModel: NSObject {
    class func getTracks(result : ([Track]) ->()) {
        let doc = Bundle.main.resourcePath!
        let fileManager = FileManager.default
        
        do {
            print("Load Data")
            let fileFromBundle = try fileManager.contentsOfDirectory(atPath: doc).filter{$0.contains(".mp3")}
            print("File: \(fileFromBundle)")
            
            var tracks = [Track]()
            var title:String = ""
            var artist:String = ""
            var artwork: Data? = nil
            
            for path in fileFromBundle {
                let audioPath = Bundle.main.url(forResource: path, withExtension: nil)
                let playerItem = AVPlayerItem(url: audioPath!)
                let metadataList = playerItem.asset.metadata
                for item in metadataList {
                    
                    if item.commonKey == nil {
                        continue
                    }
                    
                    if let key = item.commonKey, let value = item.value {
                        if key == "title" {
                            title = value as! String
                            //print("title: \(title)")
                        }
                        if key == "artist" {
                            artist = value as! String
                            //print("artist: \(artist)")
                        }
                        if key == "artwork" {
                            artwork = value as? Data
                            //print("\(artwork)")
                        } else {
                            artwork = nil
                        }
                    }
                }
                let track = Track(title: title, artist: artist, fileName: path, artwork: artwork)
                tracks.append(track)
            }
            print("Tracks: \(tracks.count)")
            result(tracks)
        } catch let error{
            print(error)
        }
    }
    
}
