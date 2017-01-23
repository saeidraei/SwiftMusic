//
//  TimeFormat.swift
//  SwiftMusic
//
//  Created by K2 on 23/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit

class TimeFormat: NSObject {
     class func getFormatTime(timerInval : TimeInterval) -> String {
        
        let min = Int(timerInval) / 60
        let sec = Int(timerInval) % 60
        return String(format: "%d:%02d", min, sec)
    }
    
     class func getFormatTimeToTimeInval(format : String) -> TimeInterval {
        let data = format.components(separatedBy: ":")
        if data.count != 2 {
            return 0
        }
        let min = TimeInterval(data[0]) ?? 0.0
        let sec = TimeInterval(data[1]) ?? 0.0
        let timeInerval = min * 60.0 + sec
        return timeInerval
    }
}
