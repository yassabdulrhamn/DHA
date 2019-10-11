//
//  NewNurseViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 3/7/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialTextFields

class NewNurseViewController: UIViewController {

    @IBOutlet weak var name: MDCTextField!
    @IBOutlet weak var email: MDCTextField!
    @IBOutlet weak var mobile: MDCTextField!
    @IBOutlet weak var password: MDCTextField!
    var post = [:] as [String : Any]
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    private let yaser = Auth.auth()
    @IBAction func createNurse(_ sender: Any)
    {
        let email_txt = email.text
        let password_txt = password.text
        yaser.createUser(withEmail: email_txt!, password: password_txt!){ (user, error) in
            if error == nil {
                
                let userID = self.yaser.currentUser?.uid
                self.post = [
                    "ID" : userID ?? "damn it!" ,
                    "Name": self.name.text ?? "noname",
                    "Mobile": self.mobile.text!,
                    "Access" : "Nurse"
                ]
                Database.database().reference().child("Users").child(userID!).setValue(self.post)
                
                print("user created")
                print("New User:")
                print(self.yaser.currentUser?.uid ?? "damn it!")
                print("old User:")
                print(Auth.auth().currentUser?.uid ?? "damn it!")
            }
            else{
                print("user is not created")
            }
        }
        
        
        
        let alertController = UIAlertController(title: "Logout", message: "take care.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            try! Auth.auth().signOut()
            self.name.text=""
            self.email.text=""
            self.mobile.text=""
            self.password.text=""
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
