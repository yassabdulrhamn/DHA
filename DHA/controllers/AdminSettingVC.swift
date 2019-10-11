//
//  AdminSettingVC.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 3/27/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import FirebaseAuth

class AdminSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
