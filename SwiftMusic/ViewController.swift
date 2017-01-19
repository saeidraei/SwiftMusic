//
//  ViewController.swift
//  SwiftMusic
//
//  Created by K2 on 17/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Start")
        
        TrackModel.getTracks { (models : [Track]) in
            print(models)
            
            
        }
        
        /*let documentUrl = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first!
        
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: documentUrl, includingPropertiesForKeys: nil, options: [])
            let mp3s = contents.filter{$0.pathExtension == "mp3"}
            print("mp3 urls: ",mp3s)
        }catch let error {
            print(error)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

