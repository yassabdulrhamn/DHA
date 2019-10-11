//
//  Records.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/10/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import Foundation
import UIKit

class Recoreds
{
    var title:String
    var value:String
    var title2:String
    var value2:String
    var date:String
    var reply:String
    
    init(title:String,value:String,title2:String,value2:String,date:String,reply:String) {
        self.title = title
        self.value = value
        self.title2 = title2
        self.value2 = value2
        self.date = date
        self.reply = reply
    }
}
