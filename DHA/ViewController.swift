//
//  ViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 1/22/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField
import Firebase
import FirebaseDatabase
import Pastel
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MaterialButtons_ColorThemer
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer
import MaterialComponents.MaterialColorScheme
import MaterialComponents.MDCSemanticColorScheme

import SQLite


class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var email: MDCTextField!
    @IBOutlet weak var password: MDCTextField!


    @IBOutlet weak var save: MDCButton!
    let button = MDCButton()
    let buttonScheme = MDCButtonScheme()
    let colorScheme = MDCSemanticColorScheme()
    // Step 2: Create or get a color scheme
    let colorScheme2 = MDCSemanticColorScheme()


    let typographyScheme = MDCTypographyScheme()

    var usernameController: MDCTextInputControllerFilled?
    var passwordController: MDCTextInputControllerFilled?

    var tham: MDCTextFieldColorThemer?
    let hsdfbdsf = MDCTextFieldColorThemer()

 //   let databaseReference = Database.database().reference()

    var database: Connection!
    let calnderTable = Table("calnder")
    let id = Expression<Int>("id")
    let pid = Expression<Int>("pid")
    let diseases = Expression<String>("diseases")
    let remindertype = Expression<String>("type")
    let datetobe = Expression<String>("datetobe")
    let done = Expression<Bool>("done")

    var dateValue: Date?
    var purdateValue: Date?
    var alertActionField = "DHA"

    var repeatingValue = Repeats.Monthly
    
    

//    func checkLoggedin()
//    {
//        if(Auth.auth().currentUser != nil)
//        {
//            self.performSegue(withIdentifier: "JumpPatientHomeTabBar", sender: Any?.self)
//
//        }
//    }
//
////    override func viewWillAppear(_ animated: Bool) {
////        let myStoryboard = self.storyboard
////        let modalViewController = myStoryboard?.instantiateViewController(withIdentifier: "PatientHomeTabBarViewController")
////        present(modalViewController!, animated: true, completion: nil)
////    }
//
//    func loggingin()
//    {
//        let uid = Auth.auth().currentUser?.uid
//        self.databaseReference.child("docApp").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
//            if !snapshot.exists() { return }
//            print(snapshot) // Its print all values including Snap (docApp)
//            print(snapshot.value!)
//            let docApp = snapshot.childSnapshot(forPath: "DateApp").value as! String
//            let docPurc = snapshot.childSnapshot(forPath: "DatePur").value as! String
//            print(docApp)
//
//            do {
//                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//                let database = try Connection(fileUrl.path)
//                self.database = database
//                self.createTable()
//                print(">> Yaser: func connect to bd.")
//                print(">> Yaser: func connect to db.")
//                print(">> Yaser: func createTable().")
//            } catch {
//                print(error)
//                print(">> Error: func connect to bd.")
//                print(">> Error: func connect to db.")
//                print(">> Error: func createTable().")
//            }
//
//            let insertdate1 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood pressure",self.remindertype <- "Visiting the doctoe",self.datetobe <- docApp,self.done <- false)
//            let insertdate2 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood pressure",self.remindertype <- "purchasing medication",self.datetobe <- docPurc,self.done <- false)
//            let insertdate3 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood sugar",self.remindertype <- "Visiting the doctoe",self.datetobe <- docApp,self.done <- false)
//            let insertdate4 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood sugar",self.remindertype <- "purchasing medication",self.datetobe <- docPurc,self.done <- false)
//            do {
//                try self.database.run(insertdate1)
//                try self.database.run(insertdate2)
//                try self.database.run(insertdate3)
//                try self.database.run(insertdate4)
//                print("Yaser: INSERTED DATA")
//            } catch {
//                print("Yaser:  Error 1")
//                print(error)
//            }
//
//            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let date = dateFormatter.date(from: docApp)
//            var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: date as! Date)
//            // Change the time to 9:30:00 in your locale
//            components.hour = 11
//            components.minute = 30
//            components.second = 0
//            print("Yaser:  Whatsapp")
//            let datetogo = gregorian.date(from: components)!
//            self.dateValue = datetogo
//            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//            let date2 = dateFormatter.date(from: docPurc)
//            components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: date2 as! Date)
//            // Change the time to 9:30:00 in your locale
//            components.hour = 11
//            components.minute = 30
//            components.second = 0
//            print("Yaser:  Whatsapp")
//            let datetogo2 = gregorian.date(from: components)!
//            self.purdateValue = datetogo2
//
//
//            self.schedule()
//
//        })
//    }
//    func createTable() {
//        print("CREATE TAPPED")
//
//        let createTable = self.calnderTable.create { (table) in
//            table.column(self.id, primaryKey: true)
//            table.column(self.pid)
//            table.column(self.diseases)
//            table.column(self.remindertype)
//            table.column(self.datetobe)
//            table.column(self.done)
//        }
//
//        do {
//            try self.database.run(createTable)
//            print("Created Table")
//            //insert data
//            //insertUser()
//        } catch {
//            print(error)
//        }
//    }
//    @objc func cancelAll() {
//        ABNScheduler.cancelAllNotifications()
//        self.view.endEditing(true)
//    }
//    @objc func schedule() {
//
//
//        var alertBody = "3 days left for your visit."
//        if (alertBody.count) > 0 && dateValue != nil {
//            let note = ABNotification(alertBody: alertBody)
//            note.alertAction = alertActionField
//            note.repeatInterval = repeatingValue
//            let _ = note.schedule(fireDate: (dateValue?.nextDays(-3))!)
//            print("notif")
//            print((dateValue?.nextDays(-3))!)
//            self.view.endEditing(true)
//        }
//        print("Notification 1 must have alert body and fire date")
//        //////////////////////////////////////////////////////////////////////
//        alertBody = "1 day left for your visit."
//        if (alertBody.count) > 0 && dateValue != nil {
//            let note = ABNotification(alertBody: alertBody)
//            note.alertAction = alertActionField
//            note.repeatInterval = repeatingValue
//            let _ = note.schedule(fireDate: (dateValue?.nextDays(-1))!)
//            print("notif")
//            print((dateValue?.nextDays(-1))!)
//            self.view.endEditing(true)
//            return
//        }
//        print("Notification 2 must have alert body and fire date")
//        //////////////////////////////////////////////////////////////////////
//        alertBody = "3 days left for your purchasing."
//        if (alertBody.count) > 0 && purdateValue != nil {
//            let note = ABNotification(alertBody: alertBody)
//            note.alertAction = alertActionField
//            note.repeatInterval = repeatingValue
//            let _ = note.schedule(fireDate: (purdateValue?.nextDays(-3))!)
//            print("notif")
//            print((purdateValue?.nextDays(-3))!)
//            self.view.endEditing(true)
//        }
//        print("Notification 1 must have alert body and fire date")
//        //////////////////////////////////////////////////////////////////////
//        alertBody = "1 day left for your purchasing."
//        if (alertBody.count) > 0 && purdateValue != nil {
//            let note = ABNotification(alertBody: alertBody)
//            note.alertAction = alertActionField
//            note.repeatInterval = repeatingValue
//            let _ = note.schedule(fireDate: (purdateValue?.nextDays(-1))!)
//            print("notif")
//            print((purdateValue?.nextDays(-1))!)
//            self.view.endEditing(true)
//            return
//        }
//        print("Notification 2 must have alert body and fire date")
//    }
    
    override func viewDidLoad() {
        
        // View Load
        //        let yaser = LunchScreanViewController()
        //        self.present(yaser, animated: true, completion: nil)
        //
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StepsVC") as! StepsVC
        //        self.present(vc, animated: true,completion: nil)
        //
        
        //        let myStoryboard = self.storyboard
        //        let modalViewController = myStoryboard?.instantiateViewController(withIdentifier: "PatientHomeTabBarViewController")
        //        present(modalViewController!, animated: true, completion: nil)
        
        
        //        UIStoryboard(name: "Main", bundle: nil)
        //            .instantiateViewController(withIdentifier: "LunchScreanViewController")
        
        super.viewDidLoad()
        //performSegue(withIdentifier: "JumpPatientHomeTabBar", sender: Any?.self)
        

        // Add Done Button:
        email.addDoneButtonOnKeyboard()
        password.addDoneButtonOnKeyboard()

        //
        usernameController = MDCTextInputControllerFilled(textInput: email)
        passwordController = MDCTextInputControllerFilled(textInput: password)

        // UIColor ::
        let mycolor1 = UIColor(red: 8/255, green: 179/255, blue: 230/255, alpha: 1)
        let mycolor1v2 = UIColor(red: 9/255, green: 124/255, blue: 197/255, alpha: 1)
        let mycolor2 = UIColor(red: 8/255, green: 179/255, blue: 230/255, alpha: 0.2)
        let mycolor3 = UIColor(red: 43/255, green: 245/255, blue: 153/255, alpha: 1)
        let mycolor4 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let mycolor5 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.2)


        // TextFiald Coloring:
        // Username
        usernameController?.normalColor = mycolor4
        usernameController?.activeColor = mycolor1
        usernameController?.borderFillColor = mycolor5
        usernameController?.leadingUnderlineLabelTextColor = mycolor1
        usernameController?.textInputClearButtonTintColor = mycolor1
        usernameController?.disabledColor = mycolor4
        usernameController?.inlinePlaceholderColor = mycolor4
        usernameController?.floatingPlaceholderActiveColor = mycolor1
        email.textColor = .white

        // password
        passwordController?.normalColor = mycolor4
        passwordController?.activeColor = mycolor1
        passwordController?.borderFillColor = mycolor5
        passwordController?.leadingUnderlineLabelTextColor = mycolor1
        passwordController?.textInputClearButtonTintColor = mycolor1
        passwordController?.disabledColor = mycolor4
        passwordController?.inlinePlaceholderColor = mycolor4
        passwordController?.floatingPlaceholderActiveColor = mycolor1
        password.textColor = .white


        // Color for button ::
        let colorScheme = MDCSemanticColorScheme()
        colorScheme.primaryColor = mycolor1
        colorScheme.onPrimaryColor = .white
        colorScheme.backgroundColor = mycolor3
        colorScheme.onBackgroundColor = mycolor3
        colorScheme.onSurfaceColor = mycolor3
        colorScheme.onSecondaryColor = mycolor3
        colorScheme.surfaceColor = mycolor3
        colorScheme.primaryColorVariant = mycolor3
        colorScheme.secondaryColor = mycolor3
        colorScheme.errorColor = mycolor3


        MDCContainedButtonColorThemer.applySemanticColorScheme(colorScheme, to: save)


        // Background ::
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        // Custom Duration
        pastelView.animationDuration = 3.0
        // Custom Color
        pastelView.setColors([mycolor1v2,
                              UIColor(red: 41/255, green: 202/255, blue: 177/255, alpha: 1.0),
                              UIColor(red: 19/255, green: 114/255, blue: 165/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    @IBAction func login(_ sender: Any) {

        // Please wait... Alert
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)


        if (self.email.text?.isEmpty == false)
        {
            print("Yaser")
            print(email.text!)
            print(password.text!)
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                if error == nil{

                    let uid = Auth.auth().currentUser?.uid
                   
                    let databaseReference = Database.database().reference()
                    databaseReference.child("Users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
                        if !snapshot.exists() { return }
                        print(snapshot) // Its print all values including Snap (User)
                        print(snapshot.value!)
                        let access = snapshot.childSnapshot(forPath: "Access").value as! String
                        print("Access :")
                        print(access)
                        switch access {
                        case "Patient":
                            print(">> Access: Patient")
                            self.getdates()
                            UserDefaults.standard.set(3, forKey: "isUserLoggedIn")
                            self.performSegue(withIdentifier: "successfullyLoggedin", sender: Any?.self)
                        case "Nurse":
                            print(">> Access: Nurse")
                            UserDefaults.standard.set(2, forKey: "isUserLoggedIn")
                            self.performSegue(withIdentifier: "successfullyLoggedinNurse", sender: Any?.self)
                        case "admin":
                            print(">> Access: Admin")
                            UserDefaults.standard.set(1, forKey: "isUserLoggedIn")
                            self.performSegue(withIdentifier: "successfullyLoggedinAdmin", sender: Any?.self)
                        default:
                            print(">> Access: none!!")
                            //Show message to call tech support
                        }
                    })
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        else
        {
            self.dismiss(animated: false, completion: nil)
            //Alert this user dosn't exists
            let alertController = UIAlertController(title: "Please", message: "fill the text felds", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    var docAppo = "01-01-2020"
    var drugAppo = "01-01-2020"
    func getdates()
    {
        let databaseReference2 = Database.database().reference()

        print("Yaser :: uid!")
        let uid = Auth.auth().currentUser?.uid
        print(uid!)
        
        
        databaseReference2.child("docAppo").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            print("Yaser :: return")
            if !snapshot.exists() { return }
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot.value!)
            self.docAppo = snapshot.childSnapshot(forPath: "dateOfAppo").value as! String
            print("docAppo:")
            print(self.docAppo)
        })

        databaseReference2.child("drugAppo").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot.value!)
            self.drugAppo = snapshot.childSnapshot(forPath: "dateOfAppo").value as! String
            print("drugAppo:")
            print(self.drugAppo)
            print("goahead 1")
            self.goahead()
            print("goahead 2")
        })

    }
    func goahead()
    {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            createTable()
        } catch {
            print(error)
        }
        
        print("Yaser:  cancelAll()")
        cancelAll()
        print("Yaser:  schedule() 1")
        schedule()
        
        print("Yaser:  schedule() 2")
        let insertdate1 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood",self.remindertype <- "Visiting the doctoe",self.datetobe <- docAppo,self.done <- false)
        let insertdate2 = self.calnderTable.insert(self.pid <- 0,self.diseases <- "blood",self.remindertype <- "purchasing medication",self.datetobe <- drugAppo,self.done <- false)
        do {
            try self.database.run(insertdate1)
            try self.database.run(insertdate2)
            print("Yaser: INSERTED DATA")
            print("Yaser: INSERTED DATA INTO FireBase")
        } catch {
            print("Yaser:  Error 1")
            print(error)
        }
        
        
        
        UserDefaults.standard.set(3, forKey: "isUserLoggedIn")
        self.performSegue(withIdentifier: "successfullyLoggedin", sender: Any?.self)
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
    
   
}
