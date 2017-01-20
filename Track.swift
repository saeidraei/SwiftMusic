//
//  Track.swift
//  SwiftMusic
//
//  Created by K2 on 19/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit

class Track: NSObject {
    var title: String
    var artist: String
    var fileName: String
    //var artwork: UIImage?
    
    init(title: String, artist: String, fileName: String) {
        self.title = title
        self.artist = artist
        self.fileName = fileName
        //self.artwork = artwork
        super.init()
    }
}
