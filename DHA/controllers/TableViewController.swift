//
//  TableViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/8/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    struct CellData {
        let image : UIImage?
        let message : String?
    }

    var data = [CellData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        data = [CellData.init(image: #imageLiteral(resourceName: "Settings"), message: "Yaser")]
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "Custom")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Custom") as! CustomCell
        cell.mainImage = data[indexPath.row].image
        cell.message = data[indexPath.row].message
        return cell
    }

}
