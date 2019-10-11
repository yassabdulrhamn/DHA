//
//  NotifyViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 3/5/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit

class NotifyViewController: UIViewController {

    var alertBodyField = "Arab open"
    var alertActionField = "Unvirsty"
    
    var dateValue: Date?
    
    var repeatingValue = Repeats.Secandly
    
    var dateFormatter: DateFormatter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //2019-03-10 13:41:00 +0000
        let date = Date()
        dateValue = date.nextMinutes(1)
        //schedule()
        cancelAll()
        
        print("Yaser")
        print(NSCalendar.Unit.minute.rawValue+1)
        
        
    }
    
    @objc func schedule() {
        let alertBody = alertBodyField
        if (alertBody.count) > 0 && dateValue != nil {
            let note = ABNotification(alertBody: alertBody)
            note.alertAction = alertActionField
            note.repeatInterval = repeatingValue
            let _ = note.schedule(fireDate: dateValue!)
            
            self.view.endEditing(true)
            return
        }
        print("Notification must have alert body and fire date")
    }
    @objc func cancelAll() {
        ABNScheduler.cancelAllNotifications()
        self.view.endEditing(true)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
