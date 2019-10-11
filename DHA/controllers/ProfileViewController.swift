//
//  ProfileViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/28/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mobile: UILabel!
    
    let databaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Nurse"
        
        
        
        let uid = Auth.auth().currentUser?.uid
        self.databaseReference.child("Users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot.value!)
            let nameFB = snapshot.childSnapshot(forPath: "Name").value as! String
            let mobileFB = snapshot.childSnapshot(forPath: "Mobile").value as! String
            self.name.text=nameFB
            self.mobile.text=mobileFB
        })
    }
    var window: UIWindow?
    @IBAction func signout(_ sender: Any)
    {
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
    
}
