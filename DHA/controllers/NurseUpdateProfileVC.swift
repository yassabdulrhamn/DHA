//
//  NurseUpdateProfileVC.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 3/22/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialTextFields

class NurseUpdateProfileVC: UIViewController {

    @IBOutlet weak var name: MDCTextField!
    @IBOutlet weak var mobile: MDCTextField!
    let databaseReference = Database.database().reference()
    
    var post = [:] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser?.uid
        self.databaseReference.child("Users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot.value!)
            let nameFB = snapshot.childSnapshot(forPath: "Name").value as! String
            let mobileFB = snapshot.childSnapshot(forPath: "Name").value as! String
            self.name.text=nameFB
            self.mobile.text=mobileFB
        })
    }
    @IBAction func NurseUpdateProfile(_ sender: Any)
    {
        
        post = [
            "Name" :  name.text ?? "error",
            "Mobile": mobile.text ?? "error"
        ]
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(userID!).updateChildValues(post)
    }
}
