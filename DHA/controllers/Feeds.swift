//
//  Feeds.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import Foundation
import UIKit

class Feeds
{
    var patien_name:String
    var value:String
    var patien_name2:String
    var value2:String
    var date:String
    var comment:String
    var id:String
    var pid:String
   
    
    
    init(patien_name:String,value:String,patien_name2:String,value2:String,date:String,comment:String,id:String,pid:String) {
        self.patien_name = patien_name
        self.patien_name2 = patien_name2
        self.value = value
        self.value2 = value2
        self.date = date
        self.comment = comment
        self.id = id
        self.pid = pid
    }
}
