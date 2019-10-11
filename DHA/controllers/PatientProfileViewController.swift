//
//  PatientProfileViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/28/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class PatientProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var dateofbirth: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var diseases: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    let databaseReference = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let uid = Auth.auth().currentUser?.uid
        self.databaseReference.child("Users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot.value!)
            self.name.text = snapshot.childSnapshot(forPath: "Name").value as? String
            self.mobile.text = snapshot.childSnapshot(forPath: "Mobile").value as? String
            self.email.text = Auth.auth().currentUser?.email
            self.dateofbirth.text = snapshot.childSnapshot(forPath: "DateofBirth").value as? String
            self.height.text = snapshot.childSnapshot(forPath: "Hight").value as? String
            self.weight.text = snapshot.childSnapshot(forPath: "Wight").value as? String
            self.diseases.text = snapshot.childSnapshot(forPath: "Name").value as? String
            self.gender.text = snapshot.childSnapshot(forPath: "Gender").value as? String
        })
    }
   
    func viewDidLoad2() {
        
        print("Yaser")
        
//        do
//        {
//            let uid = Auth.auth().currentUser?.uid
//            self.databaseReference.child("Users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
//                if !snapshot.exists() { return }
//                print(snapshot) // Its print all values including Snap (User)
//                print(snapshot.value!)
//                //self.name.text = ""
//            })
//        }

    }
    var window: UIWindow?
    @IBAction func signoutprofile(_ sender: Any) {

        let alertController = UIAlertController(title: "Logout", message: "take care.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            try! Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginpage") as! ViewController
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = loginVC
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
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
