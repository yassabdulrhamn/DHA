//
//  SignUpViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/13/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import QuartzCore

class SignUpViewController: UIViewController {

    @IBAction func removered(_ sender: Any) {
        let myColor = UIColor.blue
        texfield_verfiy.layer.borderColor = myColor.cgColor
    }
    var post = [:] as [String : Any]
    var tex_verfiy:String = ""
    
    //Next:
    @IBOutlet weak var texfield_verfiy: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func butt_signup(_ sender: Any)
    {
        let defaults = UserDefaults.standard

        do
        {
            let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: texfield_verfiy.text!)
            Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                } else {
                    // Yaser :: Loading alert
                    let userID = Auth.auth().currentUser?.uid
                    self.post["ID"]=userID
                    Database.database().reference().child("Users").child(userID!).setValue(self.post)
                    UserDefaults.standard.set(3, forKey: "isUserLoggedIn")
                    self.performSegue(withIdentifier: "Selectdates", sender: Any?.self)
                }
            }
        }
        catch
        {
            texfield_verfiy.text=""
            let myColor = UIColor.red
            texfield_verfiy.layer.borderColor = myColor.cgColor
        }
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
