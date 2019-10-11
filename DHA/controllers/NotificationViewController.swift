//
//  NotificationViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/8/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    var notifications: [Notification] = []
    @IBOutlet weak var TableView: UITableView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        //notifications = createArray()
        TableView.delegate = self
        TableView.dataSource = self
            
    }
    
    func createArray() -> [Notification]
    {
        var cells: [Notification] = []
        
        let notifiecation1 = Notification(icon: #imageLiteral(resourceName: "Chart"), title: "Test", message: "Message")
        let notifiecation2 = Notification(icon: #imageLiteral(resourceName: "Chart"), title: "Test", message: "Message")

        
        cells.append(notifiecation1)
        cells.append(notifiecation2)

        
         
        return cells
    }
}
extension NotificationViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = notifications[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! TableViewCell
        
        cell.setNotification(notification: notification)
        return cell
    }
}
