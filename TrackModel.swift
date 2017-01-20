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
        //1 获取文件路径
        let doc = Bundle.main.resourcePath!
        let fileManager = FileManager.default
        
        
        do {
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
                let track = Track(title: title, artist: artist, fileName: path)
                tracks.append(track)
            }
            print("Tracks: \(tracks.count)")
            result(tracks)
        } catch let error{
            print(error)
        }
    }
    
}
