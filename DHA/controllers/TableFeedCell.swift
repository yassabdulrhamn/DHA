//
//  TableFeedCell.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit

class TableFeedCell: UITableViewCell {

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var value2: UILabel!
    @IBOutlet weak var patient_name: UILabel!
    @IBOutlet weak var patient_name2: UILabel!
    @IBOutlet weak var date: UILabel!
    //@IBOutlet weak var comment: UILabel!

    
    func setFeed(feed : Feeds)
    {
        patient_name.text = feed.patien_name
        value.text = feed.value
        date.text = feed.date
        patient_name2.text = feed.patien_name2
        value2.text = feed.value2
        date.isHidden=true
    }
}
