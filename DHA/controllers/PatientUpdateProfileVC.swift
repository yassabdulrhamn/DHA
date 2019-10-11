//
//  PatientUpdateProfileVC.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 3/23/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialTextFields

class PatientUpdateProfileVC: UIViewController {
    
    @IBOutlet weak var name: MDCTextField!
    @IBOutlet weak var mobile: MDCTextField!
    @IBOutlet weak var weight: MDCTextField!
    @IBOutlet weak var height: MDCTextField!
    @IBOutlet weak var switch_Grnder: UISegmentedControl!

    
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
            let mobileFB = snapshot.childSnapshot(forPath: "Mobile").value as! String
            let weightFB = snapshot.childSnapshot(forPath: "Wight").value as! String
            let heightFB = snapshot.childSnapshot(forPath: "Hight").value as! String
            let genderFB = snapshot.childSnapshot(forPath: "Gender").value as! String
            
            self.name.text=nameFB
            self.mobile.text=mobileFB
            self.weight.text=weightFB
            self.mobile.text=mobileFB
            self.height.text=heightFB
            
            if(genderFB=="Male")
            {
                self.switch_Grnder.selectedSegmentIndex=0
            }
            else
            {
                self.switch_Grnder.selectedSegmentIndex=1
            }

        })
    }
    
    @IBAction func NurseUpdateProfile(_ sender: Any)
    {
        var gender="Male"
        if(self.switch_Grnder.selectedSegmentIndex==0)
        {
            gender="Male"
        }
        else
        {
            gender="Female"
        }
        post = [
            "Name" :  name.text ?? "error",
            "Hight" :  height.text ?? "error",
            "Wight" :  weight.text ?? "error",
            "Gender" :  gender,
            "Mobile": mobile.text ?? "error"
        ]
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(userID!).updateChildValues(post)
        
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        PatientProfileViewController().viewDidLoad2()
    }
}
