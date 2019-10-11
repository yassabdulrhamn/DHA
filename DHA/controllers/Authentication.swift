//
//  Authentication.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 1/27/19.
//  Copyright Â© 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialTextFields

class Authentication: UIViewController {
    
    
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet weak var viewhight: NSLayoutConstraint!
    
    @IBOutlet weak var tex_name: MDCTextField!
    @IBOutlet weak var tex_mobile: MDCTextField!
    @IBOutlet weak var tex_password: MDCTextField!
    @IBOutlet weak var tex_email: MDCTextField!
    @IBOutlet weak var switch_Grnder: UISegmentedControl!
    @IBOutlet weak var dob:UIDatePicker!
    @IBOutlet weak var tex_hight: MDCTextField!
    @IBOutlet weak var tex_wight: MDCTextField!
    @IBOutlet weak var checkbox_mayo: CheckBox!
    @IBOutlet weak var checkbox_bloodp: CheckBox!
    @IBOutlet weak var medicalHistory: MDCTextField!
    
    
    var tex_nameV: MDCTextInputControllerFilled?
    var tex_mobileV:  MDCTextInputControllerFilled?
    var tex_passwordV: MDCTextInputControllerFilled?
    var passwordController:  MDCTextInputControllerFilled?
    var tex_emailV: MDCTextInputControllerFilled?
    var tex_hightV:  MDCTextInputControllerFilled?
    var tex_wightV: MDCTextInputControllerFilled?
    var medicalHistoryV: MDCTextInputControllerFilled?
    
    
    var post = [:] as [String : Any]
    
    
    override func viewDidLoad() {
        
        styling()
        super.viewDidLoad()


    }

    
    @IBAction func signUpAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: tex_email.text!, password: tex_password.text!){ (user, error) in
            if error == nil {
                if(self.register_info())
                {
                    UserDefaults.standard.set(3, forKey: "isUserLoggedIn")
                    self.performSegue(withIdentifier: "Selectdates", sender: Any?.self)
                }
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func register_info() -> Bool
    {
        let selected_gender:String
        if (switch_Grnder.selectedSegmentIndex == 0)
        {
            selected_gender = "Male"
        }
        else if (switch_Grnder.selectedSegmentIndex == 1)
        {
            selected_gender = "Female"
        }
        else
        {selected_gender = "None"}
        
        let BloodPressure:Bool
        if(checkbox_bloodp.isChecked)
        {
            BloodPressure=false
        }
        else
        {
            BloodPressure=true
        }
        
        let MayoClinic:Bool
        if(checkbox_mayo.isChecked)
        {
            MayoClinic=false
        }
        else
        {
            MayoClinic=true
        }
        
        //let userID = Auth.auth().currentUser?.uid
        let userMobile = self.tex_mobile.text
        let userName = self.tex_name.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let strDate = dateFormatter.string(from: self.dob.date)
        let userDOB = strDate
        let userHight = self.tex_hight.text
        let userWight = self.tex_wight.text
        
        post = [
            "ID" : Auth.auth().currentUser?.uid ?? "error" ,
            "Name": userName ?? "noname",
            "Mobile": userMobile!,
            "Gender":  selected_gender,
            "DateofBirth":  userDOB ,
            "Hight" : userHight!,
            "Wight" : userWight!,
            "Access" : "Patient",
            "BloodPressure" : BloodPressure,
            "BloodSugar" : MayoClinic,
            "statue" : "false",
            "medicalHistory" : "false"
        ]
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(userID!).setValue(post)
        return true
    }
    
    // Yaser :: valdate inputs
    func valdationing() -> Bool {
        return true
    }
    
    func styling()
    {
        tex_mobile.keyboardType = UIKeyboardType.phonePad
        tex_hight.keyboardType = UIKeyboardType.numberPad
        tex_wight.keyboardType = UIKeyboardType.numberPad
        tex_email.keyboardType = UIKeyboardType.emailAddress
//        tex_name.addDoneButtonOnKeyboard()
//        tex_mobile.addDoneButtonOnKeyboard()
//        tex_password.addDoneButtonOnKeyboard()
//        tex_email.addDoneButtonOnKeyboard()
//        tex_wight.addDoneButtonOnKeyboard()
//        tex_hight.addDoneButtonOnKeyboard()
        
        
        
        // Add Done Button:
        tex_name.addDoneButtonOnKeyboard()
        tex_mobile.addDoneButtonOnKeyboard()
        tex_password.addDoneButtonOnKeyboard()
        tex_email.addDoneButtonOnKeyboard()
        tex_hight.addDoneButtonOnKeyboard()
        tex_wight.addDoneButtonOnKeyboard()
        medicalHistory.addDoneButtonOnKeyboard()
        
        tex_nameV = MDCTextInputControllerFilled(textInput: tex_name)
        tex_mobileV =  MDCTextInputControllerFilled(textInput: tex_mobile)
        tex_passwordV = MDCTextInputControllerFilled(textInput: tex_password)
        tex_emailV =  MDCTextInputControllerFilled(textInput: tex_email)
        tex_hightV = MDCTextInputControllerFilled(textInput: tex_hight)
        tex_wightV =  MDCTextInputControllerFilled(textInput: tex_wight)
        medicalHistoryV =  MDCTextInputControllerFilled(textInput: medicalHistory)
        
        
        // UIColor ::
        let mycolor1 = UIColor(red: 8/255, green: 179/255, blue: 230/255, alpha: 1)
//        let mycolor1v2 = UIColor(red: 9/255, green: 124/255, blue: 197/255, alpha: 1)
//        let mycolor2 = UIColor(red: 8/255, green: 179/255, blue: 230/255, alpha: 0.2)
//        let mycolor3 = UIColor(red: 43/255, green: 245/255, blue: 153/255, alpha: 1)
        let mycolor4 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let mycolor5 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.2)
        
        
        // TextFiald Coloring:
        
        // MedicalHistoryV
        medicalHistoryV?.normalColor = mycolor4
        medicalHistoryV?.activeColor = mycolor1
        medicalHistoryV?.borderFillColor = mycolor5
        medicalHistoryV?.leadingUnderlineLabelTextColor = mycolor1
        medicalHistoryV?.textInputClearButtonTintColor = mycolor1
        medicalHistoryV?.disabledColor = mycolor4
        medicalHistoryV?.inlinePlaceholderColor = mycolor4
        medicalHistoryV?.floatingPlaceholderActiveColor = mycolor1
        medicalHistory.textColor = .white
        
        // Username
        tex_nameV?.normalColor = mycolor4
        tex_nameV?.activeColor = mycolor1
        tex_nameV?.borderFillColor = mycolor5
        tex_nameV?.leadingUnderlineLabelTextColor = mycolor1
        tex_nameV?.textInputClearButtonTintColor = mycolor1
        tex_nameV?.disabledColor = mycolor4
        tex_nameV?.inlinePlaceholderColor = mycolor4
        tex_nameV?.floatingPlaceholderActiveColor = mycolor1
        tex_name.textColor = .white
        
        // Password
        tex_mobileV?.normalColor = mycolor4
        tex_mobileV?.activeColor = mycolor1
        tex_mobileV?.borderFillColor = mycolor5
        tex_mobileV?.leadingUnderlineLabelTextColor = mycolor1
        tex_mobileV?.textInputClearButtonTintColor = mycolor1
        tex_mobileV?.disabledColor = mycolor4
        tex_mobileV?.inlinePlaceholderColor = mycolor4
        tex_mobileV?.floatingPlaceholderActiveColor = mycolor1
        tex_mobile.textColor = .white
        
        // TextFiald Coloring:
        // Username
        tex_passwordV?.normalColor = mycolor4
        tex_passwordV?.activeColor = mycolor1
        tex_passwordV?.borderFillColor = mycolor5
        tex_passwordV?.leadingUnderlineLabelTextColor = mycolor1
        tex_passwordV?.textInputClearButtonTintColor = mycolor1
        tex_passwordV?.disabledColor = mycolor4
        tex_passwordV?.inlinePlaceholderColor = mycolor4
        tex_passwordV?.floatingPlaceholderActiveColor = mycolor1
        tex_password.textColor = .white
        
        // Password
        tex_emailV?.normalColor = mycolor4
        tex_emailV?.activeColor = mycolor1
        tex_emailV?.borderFillColor = mycolor5
        tex_emailV?.leadingUnderlineLabelTextColor = mycolor1
        tex_emailV?.textInputClearButtonTintColor = mycolor1
        tex_emailV?.disabledColor = mycolor4
        tex_emailV?.inlinePlaceholderColor = mycolor4
        tex_emailV?.floatingPlaceholderActiveColor = mycolor1
        tex_email.textColor = .white
        
        // TextFiald Coloring:
        // Username
        tex_hightV?.normalColor = mycolor4
        tex_hightV?.activeColor = mycolor1
        tex_hightV?.borderFillColor = mycolor5
        tex_hightV?.leadingUnderlineLabelTextColor = mycolor1
        tex_hightV?.textInputClearButtonTintColor = mycolor1
        tex_hightV?.disabledColor = mycolor4
        tex_hightV?.inlinePlaceholderColor = mycolor4
        tex_hightV?.floatingPlaceholderActiveColor = mycolor1
        tex_hight.textColor = .white
        
        // Password
        tex_wightV?.normalColor = mycolor4
        tex_wightV?.activeColor = mycolor1
        tex_wightV?.borderFillColor = mycolor5
        tex_wightV?.leadingUnderlineLabelTextColor = mycolor1
        tex_wightV?.textInputClearButtonTintColor = mycolor1
        tex_wightV?.disabledColor = mycolor4
        tex_wightV?.inlinePlaceholderColor = mycolor4
        tex_wightV?.floatingPlaceholderActiveColor = mycolor1
        tex_wight.textColor = .white
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//    @IBAction func butt_signup2(_ sender: Any) {
//
//        //    let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(fullMobileNumber)", preferredStyle: .alert)
//        //    let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
//        //        PhoneAuthProvider.provider().verifyPhoneNumber(fullMobileNumber, uiDelegate: nil) { (verificationID, error) in
//        //            if error != nil {
//        //                print("eror: \(String(describing: error?.localizedDescription))")
//        //            } else {
//        //                let defaults = UserDefaults.standard
//        //                defaults.set(verificationID, forKey: "authVID")
//        //                print("Yaser: "+verificationID!)
//        //                self.performSegue(withIdentifier: "code", sender: Any?.self)
//        //            }
//        //        }
//        //    }
//        //    let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
//        //    alert.addAction(action)
//        //    alert.addAction(cancel)
//        //    self.present(alert, animated: true, completion: nil)
//
//
//        ///////////////////////
//        //
//        //        let selected_gender:String
//        //        if (switch_Grnder.selectedSegmentIndex == 0)
//        //        {
//        //            selected_gender = "Male"
//        //        }
//        //        else if (switch_Grnder.selectedSegmentIndex == 1)
//        //        {
//        //            selected_gender = "Female"
//        //        }
//        //        else
//        //        {selected_gender = "None"}
//        //
//        //        let BloodPressure:Bool
//        //        if(checkbox_bloodp.isChecked)
//        //        {
//        //            BloodPressure=false
//        //        }
//        //        else
//        //        {
//        //            BloodPressure=true
//        //        }
//        //
//        //        let MayoClinic:Bool
//        //        if(checkbox_mayo.isChecked)
//        //        {
//        //            MayoClinic=false
//        //        }
//        //        else
//        //        {
//        //            MayoClinic=true
//        //        }
//        //
//        //
//        //
//        //        if let email = tex_email.text, let password = tex_password.text {
//        //            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//        //                print("Register email and password success")
//        //                let userID = Auth.auth().currentUser?.uid
//        //                let userMobile = self.tex_mobile.text
//        //                let userName = self.tex_name.text
//        //                let dateFormatter = DateFormatter()
//        //                dateFormatter.dateFormat = "dd-MM-YYYY"
//        //                let strDate = dateFormatter.string(from: self.dob.date)
//        //                let userDOB = strDate
//        //                let userHight = self.tex_hight.text
//        //                let userWight = self.tex_wight.text
//        //
//        //                let post = [
//        //                    "ID" : userID ?? "no id" ,
//        //                    "Name": userName ?? "noname",
//        //                    "Mobile": userMobile!,
//        //                    "Gender":  selected_gender,
//        //                    "DateofBirth":  userDOB ,
//        //                    "Hight" : userHight!,
//        //                    "Wight" : userWight!,
//        //                    "Access" : "Patient",
//        //                    "Blood Pressure" : BloodPressure,
//        //                    "Mayo Clinic" : MayoClinic ,
//        //                    ] as [String : Any]
//        //                Database.database().reference().child("Users").child(userID!).setValue(post)
//        //                return
//        //                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//        //                        print("Loged in")
//        //                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        //                        let patientViewController = storyBoard.instantiateViewController(withIdentifier: "patientViewController") as! patientControllerViewController
//        //                        self.present(patientViewController, animated: true, completion: nil)
//        //                }
//        //            }
//        //        }
//        //
//    }


//    @IBAction func butt_verify(_ sender: Any) {
//
//        // Valdete the inputes:
//        if(valdationing())
//        {
//
//
//
//
//            let fullMobileNumber = "+"+self.tex_mobile.text!
//            let mobile = self.tex_mobile.text
//            if (self.tex_mobile.text?.isEmpty == false)
//            {
//                let databaseRef = Database.database().reference()
//                databaseRef.child("Users").queryOrdered(byChild: "Mobile").queryEqual(toValue: mobile).observeSingleEvent(of: DataEventType.value) { (snapshot) in
//
//                    if snapshot.exists() {
//                        //self.dismiss(animated: false, completion: nil)
//                        //Alert this user dosn't exists
//                        let alertController = UIAlertController(title: "already exists", message: "This mobile is already registerd.", preferredStyle: .alert)
//                        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
//                        }
//                        alertController.addAction(action1)
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                    else
//                    {
//                        let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(fullMobileNumber)", preferredStyle: .alert)
//                        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
//                            // Yaser :: Show loding message alert.
//                            PhoneAuthProvider.provider().verifyPhoneNumber(fullMobileNumber, uiDelegate: nil) { (verificationID, error) in
//                                if error != nil {
//                                    print("eror: \(String(describing: error?.localizedDescription))")
//                                } else {
//                                    let defaults = UserDefaults.standard
//                                    defaults.set(verificationID, forKey: "authVID")
//                                    //  func prepare will be excuted
//                                    self.performSegue(withIdentifier: "verfiy_phone_number", sender: Any?.self)
//                                }
//                            }
//                        }
//                        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
//                        alert.addAction(action)
//                        alert.addAction(cancel)
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//
//    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "verfiy_phone_number"){
//            let displayVC = segue.destination as! SignUpViewController
//            displayVC.post = register_info()
//            // Yaser :: most likely i don't need the following: displayVC.tex_verfiy = "+"+self.tex_mobile.text!
//            displayVC.tex_verfiy = "+"+self.tex_mobile.text!
//        }
//    }
