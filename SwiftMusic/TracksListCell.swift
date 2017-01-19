//
//  TracksListCell.swift
//  SwiftMusic
//
//  Created by K2 on 18/01/2017.
//  Copyright © 2017 K2. All rights reserved.
//

import UIKit

class TracksListCell: UITableViewCell {
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set table selection color
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 78/255, green: 82/255, blue: 93/255, alpha: 0.6)
        selectedBackgroundView  = selectedView
    }
    
    func configureTrackCell(track: Track) {
        
        // Configure the cell...
        trackTitle.text = track.title
        artist.text = track.artist
        
        
        

            trackImage.image = UIImage(named: "albumArt")

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackTitle.text  = nil
        trackTitle.text  = nil
        trackImage.image = nil
    }
}
