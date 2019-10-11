//
//  Notification.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/9/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import Foundation
import UIKit

class Notification
{
    var icon: UIImage
    var title: String
    var message: String
    
    init(icon: UIImage,title: String,message: String) {
       self.icon = icon
        self.title = title
        self.message = message
    }
}
