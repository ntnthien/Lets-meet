//
//  EventDetailTableViewCell.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/15/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class EventDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(event: Event) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd'-'MM'-'yyyy' 'HH':'mm':'ss"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 7)
        let date = formatter.stringFromDate(NSDate(timeIntervalSince1970: event.time!))
        
        timeLabel.text = "\(date)"
        if let location = event.getLocation() {
            locationLabel.text = location
        }
        descriptionLabel.text = event.description
    }
}
