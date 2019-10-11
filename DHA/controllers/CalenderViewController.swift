//
//  CalenderViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 3/6/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import DownPicker
import FSCalendar
import SQLite
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CalenderViewController: UIViewController, FSCalendarDelegate {
    
    var database: Connection!
    
    let usersTable = Table("user")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let bplsure = Expression<Bool>("bplsure")
    let bsuger = Expression<Bool>("bsuger")
    
    let calnderTable = Table("calnder")
    let pid = Expression<Int>("pid")
    let diseases = Expression<String>("diseases")
    let remindertype = Expression<String>("type")
    let datetobe = Expression<String>("datetobe")
    let done = Expression<Bool>("done")
    
    var alertBodyField = "DHA"
    var alertActionField = "DHA"
    
    var dateValue: Date?
    var purdateValue: Date?
    
    var repeatingValue = Repeats.Monthly
    
    var dateFormatter: DateFormatter!
    
    @IBOutlet weak var datepicker: FSCalendar!
    @IBOutlet weak var diseaseTypeTF: UITextField!
    
    @IBOutlet weak var visiting: UILabel!
    @IBOutlet weak var purchasing: UILabel!

    @IBOutlet weak var calendar: FSCalendar!
    var post = [:] as [String : Any]
    
    var diseaseTypeDownPicker: DownPicker!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        calendar.delegate = self
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            createTable()
        } catch {
            print(error)
        }
        let diseaseType: NSMutableArray = ["Visiting the doctoe", "Purchase medication"]
        self.diseaseTypeDownPicker = DownPicker(textField: self.diseaseTypeTF, withData:diseaseType as? [Any])

    }
    func postFB()
    {
        let userID = Auth.auth().currentUser?.uid
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        let nowDate = formatter.string(from: date)
        
        post = [
            "PatientID" : userID ?? "error" ,
            "dateEntered": nowDate,
            "dateOfAppo": visiting.text ?? "error"
        ]
        Database.database().reference().child("docAppo").child(userID!).setValue(post)
        post = [
            "PatientID" : userID ?? "error" ,
            "dateEntered": nowDate,
            "dateOfAppo": purchasing.text ?? "error"
        ]
        Database.database().reference().child("drugAppo").child(userID!).setValue(post)
    }
    
    @IBAction func endedit(_ sender: Any) {
        print("Yaser: endedit")
    }
    @IBAction func savedate(_ sender: Any) {
        
        if(visiting.text != "." && purchasing.text != ".")
        {
            
            print("Yaser:  cancelAll()")
            cancelAll()
            print("Yaser:  schedule() 1")
            schedule()
            
            print("Yaser:  schedule() 2")
            let insertdate1 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood",self.remindertype <- "Visiting the doctoe",self.datetobe <- visiting.text!,self.done <- false)
            let insertdate2 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood",self.remindertype <- "purchasing medication",self.datetobe <- purchasing.text!,self.done <- false)
            do {
                try self.database.run(insertdate1)
                try self.database.run(insertdate2)
                print("Yaser: INSERTED DATA")
                postFB()
                print("Yaser: INSERTED DATA INTO FireBase")
            } catch {
                print("Yaser:  Error 1")
                print(error)
            }
            self.performSegue(withIdentifier: "PatientHomeTabBar", sender: Any?.self)
        }
        else
        {
            let alert = UIAlertController(title: "Please", message: "Select a date, and an item", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
//        if((datepicker.selectedDate) != nil && personTextField.text?.count ?? 0>0 && diseaseTypeTF.text?.count ?? 0>0)
//        {
//
//            print("Yaser:  schedule() 1")
//            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//            let now = datepicker.selectedDate
//            var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now as! Date)
//
//            // Change the time to 9:30:00 in your locale
//            components.hour = 11
//            components.minute = 30
//            components.second = 0
//            print("Yaser:  schedule() 2")
//            let date = gregorian.date(from: components)!
//
//            dateValue = date
//            print("Yaser:  cancelAll()")
//            cancelAll()
//            print("Yaser:  schedule()")
//            schedule()
//
//            print("INSERT TAPPED")
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            //let datetobeString = formatter.string(from: dateValue!)
//
//            let insertdate1 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood pressure",self.remindertype <- "Visiting the doctoe",self.datetobe <- visiting.text!,self.done <- false)
//            let insertdate2 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood pressure",self.remindertype <- "purchasing medication",self.datetobe <- purchasing.text!,self.done <- false)
//            let insertdate3 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood sugar",self.remindertype <- "Visiting the doctoe",self.datetobe <- visiting.text!,self.done <- false)
//            let insertdate4 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood sugar",self.remindertype <- "purchasing medication",self.datetobe <- purchasing.text!,self.done <- false)
//            do {
//                try self.database.run(insertdate1)
//                try self.database.run(insertdate2)
//                try self.database.run(insertdate3)
//                try self.database.run(insertdate4)
//                print("INSERTED DATA")
//            } catch {
//                print(error)
//            }
//
//            self.performSegue(withIdentifier: "PatientHomeTabBar", sender: Any?.self)
//        }
//        else
//        {
//            let alert = UIAlertController(title: "Please", message: "Select a date, and an item", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        
        
    }
    
    func createTable() {
        print("CREATE TAPPED")
        
        let createTable = self.calnderTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.pid)
            table.column(self.diseases)
            table.column(self.remindertype)
            table.column(self.datetobe)
            table.column(self.done)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
            //insert data
            //insertUser()
        } catch {
            print(error)
        }
    }
    
    
    @objc func schedule() {

        
        var alertBody = "3 days left for your visit."
        if (alertBody.count) > 0 && dateValue != nil {
            let note = ABNotification(alertBody: alertBody)
            note.alertAction = alertActionField
            note.repeatInterval = repeatingValue
            let _ = note.schedule(fireDate: (dateValue?.nextDays(-3))!)
            print("notif")
            print((dateValue?.nextDays(-3))!)
            self.view.endEditing(true)
        }
        print("Notification 1 must have alert body and fire date")
        //////////////////////////////////////////////////////////////////////
         alertBody = "1 day left for your visit."
        if (alertBody.count) > 0 && dateValue != nil {
            let note = ABNotification(alertBody: alertBody)
            note.alertAction = alertActionField
            note.repeatInterval = repeatingValue
            let _ = note.schedule(fireDate: (dateValue?.nextDays(-1))!)
            print("notif")
            print((dateValue?.nextDays(-1))!)
            self.view.endEditing(true)
            return
        }
        print("Notification 2 must have alert body and fire date")
        //////////////////////////////////////////////////////////////////////
        alertBody = "3 days left for your purchasing."
        if (alertBody.count) > 0 && purdateValue != nil {
            let note = ABNotification(alertBody: alertBody)
            note.alertAction = alertActionField
            note.repeatInterval = repeatingValue
            let _ = note.schedule(fireDate: (purdateValue?.nextDays(-3))!)
            print("notif")
            print((purdateValue?.nextDays(-3))!)
            self.view.endEditing(true)
        }
        print("Notification 1 must have alert body and fire date")
        //////////////////////////////////////////////////////////////////////
        alertBody = "1 day left for your purchasing."
        if (alertBody.count) > 0 && purdateValue != nil {
            let note = ABNotification(alertBody: alertBody)
            note.alertAction = alertActionField
            note.repeatInterval = repeatingValue
            let _ = note.schedule(fireDate: (purdateValue?.nextDays(-1))!)
            print("notif")
            print((purdateValue?.nextDays(-1))!)
            self.view.endEditing(true)
            return
        }
        print("Notification 2 must have alert body and fire date")
    }
    @objc func cancelAll() {
        ABNScheduler.cancelAllNotifications()
        self.view.endEditing(true)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Yaser")
        if(diseaseTypeTF.text=="Purchase medication")
        {
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let now = datepicker.selectedDate
            var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now as! Date)
            
            // Change the time to 9:30:00 in your locale
            components.hour = 11
            components.minute = 30
            components.second = 0
            print("Yaser:  Whatsapp")
            let date = gregorian.date(from: components)!

            purdateValue = date
            
            print("INSERT TAPPED")
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
            
            let datetobeString = formatter.string(from: purdateValue!)
            
            purchasing.text=datetobeString
        }
        else if(diseaseTypeTF.text=="Visiting the doctoe")
        {
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let now = datepicker.selectedDate
            var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now as! Date)
            
            // Change the time to 9:30:00 in your locale
            components.hour = 11
            components.minute = 30
            components.second = 0
            print("Yaser:  Whatsapp")
            let date = gregorian.date(from: components)!
            
            dateValue = date
            
            print("INSERT TAPPED")
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
            
            let datetobeString = formatter.string(from: dateValue!)
            visiting.text=datetobeString
        }
        else
        {
            calendar.deselect(calendar.selectedDate!)
            let alert = UIAlertController(title: "Please", message: "Select from the menu up.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


    


}
