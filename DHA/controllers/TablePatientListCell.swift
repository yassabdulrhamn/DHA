//
//  TablePatientListCell.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit

class TablePatientListCell: UITableViewCell {

    @IBOutlet weak var pationtGender: UIImageView!
    @IBOutlet weak var pationtName: UILabel!
    
    func setList(patient : Patients)
    {
        pationtGender.image = patient.patien_gender
        pationtName.text = patient.patien_name
    }

}

