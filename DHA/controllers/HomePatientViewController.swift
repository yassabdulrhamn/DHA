//
//  HomePatientViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/6/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialTextFields
import SQLite
class HomePatientViewController: UIViewController {
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var textfield_bloodpressure: MDCTextField!
    @IBOutlet weak var textfield_bloodpressure2: MDCTextField!
    @IBOutlet weak var textfield_bloodsugar: MDCTextField!
    @IBOutlet weak var daysleft1: UILabel!
    @IBOutlet weak var daysleft2: UILabel!
    
    let databaseReference = Database.database().reference()
    var post = [:] as [String : Any]
    
    var daysleftvist = 0
    var daysleftmed = 0
    
    var database: Connection!
    let userCalender = Table("calender")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    let calnderTable = Table("calnder")
    let pid = Expression<Int>("pid")
    let diseases = Expression<String>("diseases")
    let remindertype = Expression<String>("type")
    let datetobe = Expression<String>("datetobe")
    let done = Expression<Bool>("done")
    

    
    func daysleft()
    {
        do {
            do {
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
                let database = try Connection(fileUrl.path)
                self.database = database
            } catch {
                print(error)
            }
            
            let calnderofp = try self.database.prepare(self.calnderTable)
            for counter in calnderofp {
                print("Id: \(counter[self.id]), disease: \(counter[self.diseases]), date: \(counter[self.datetobe])")
                
                print("Id: \(counter[self.id]), disease: \(counter[self.diseases]), date: \(counter[self.datetobe])")

                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "dd-MM-yyyy" //Your date format
                dateFormatter2.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                //according to date format your date string
                
                guard let date4 = dateFormatter2.date(from: counter[self.datetobe]) else {
                    fatalError()
                }
                print(date4) //Convert String to Date
                print(Date())
                let calendar = Calendar.current
                
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: Date())
                let date2 = calendar.startOfDay(for: date4)
                
                print("google")
                

                
                
                
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                print("components: ")
                print(components.day!)
                let switch_key = counter[self.remindertype]
                print("switch_key: " + switch_key)
                switch switch_key
                {
                   case "Visiting the doctoe":
                    daysleft2.text=String(components.day!)
                   case "purchasing medication":
                    daysleft1.text=String(components.day!)
                default:
                    print("Yaser: default")
                }
            }
        } catch {
            print(error)
        }
        
        let leftdays = ""
        print(leftdays)
    }
    
    override func viewDidLoad() {
        
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10
        
        textfield_bloodpressure.keyboardType = UIKeyboardType.numberPad
        textfield_bloodpressure2.keyboardType = UIKeyboardType.numberPad
        textfield_bloodsugar.keyboardType = UIKeyboardType.numberPad
        // Add Done Button:
        textfield_bloodpressure.addDoneButtonOnKeyboard()
        textfield_bloodpressure2.addDoneButtonOnKeyboard()
        textfield_bloodsugar.addDoneButtonOnKeyboard()
        
        super.viewDidLoad()
        
        daysleft()
        


        // Do any additional setup after loading the view.
    }
    @IBAction func save(_ sender: Any) {
        
        let uid = Auth.auth().currentUser?.uid
        self.databaseReference.child("Users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot.value!)
            if(snapshot.childSnapshot(forPath: "statue").value as? String == "True")
            {
                let alertController = UIAlertController(title: "Any thing to add?", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "do you feel any thing?"
                }
                let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                    let firstTextField = alertController.textFields![0] as UITextField
                    
                    
                    let bloodpressure = self.textfield_bloodpressure.text! + "/" + self.textfield_bloodpressure2.text!
                    let bloodsugar = self.textfield_bloodsugar.text
                    
                    let userID = Auth.auth().currentUser?.uid
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let nowDate = formatter.string(from: date)
                    
                    self.post.removeAll()
                    self.post = [
                        "BloodPressure" : bloodpressure,
                        "BloodSugar": bloodsugar ?? "false",
                        "Comment": "false",
                        "DateEntered":  nowDate,
                        "DateReplyed":  "false" ,
                        "NurseId" : "false",
                        "PatientID" : userID!,
                        "Statue" : "New",
                        "ThumpsUp" : "false",
                        "ptCurrentStatue" : firstTextField.text ?? ""
                    ]
                    
                    do
                    {
                        
                        self.databaseReference.child("Vitals").childByAutoId().setValue(self.post)
                        self.textfield_bloodpressure.text=""
                        self.textfield_bloodpressure2.text=""
                        self.textfield_bloodsugar.text=""
                    }
                    
                })
                alertController.addAction(saveAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let alertController = UIAlertController(title: "Sorry", message: "You are still not approved by any nurse", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
        })
}

}
