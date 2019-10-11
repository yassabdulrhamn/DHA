//
//  TableRecordsCell.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/10/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit

class TableRecordsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var value2: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var reply: UILabel!
    
    func setRecored(record : Recoreds)
    {
        title.text = record.title
        value.text = record.value
        title2.text = record.title2
        value2.text = record.value2
        date.text = record.date
        reply.text = record.reply
    }

}
