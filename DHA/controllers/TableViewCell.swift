//
//  TableViewCell.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/9/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var IconCell: UIImageView!
    @IBOutlet weak var CellLable: UILabel!
    @IBOutlet weak var CellText: UILabel!
    
    func setNotification(notification : Notification)
    {
        IconCell.image = notification.icon
        CellLable.text = notification.title
        CellText.text = notification.message
    }


//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
