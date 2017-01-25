//
//  TrackMessage.swift
//  SwiftMusic
//
//  Created by K2 on 19/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit

class TrackMessage: NSObject {
    var trackModel : Track?
    var currentTime : TimeInterval = 0
    var totalTime : TimeInterval = 0
    var isPlaying : Bool = false
}
