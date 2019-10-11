//
//  PatientList.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import Foundation
import UIKit

class Patients
{
    var patien_id:String
    var patien_name:String
    var patien_gender:UIImage
    
    init(patien_id: String,patien_name: String,patien_gender: UIImage)
    {
        self.patien_id = patien_id
        self.patien_gender = patien_gender
        self.patien_name = patien_name
    }
}
