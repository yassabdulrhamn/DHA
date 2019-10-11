//
//  PatientRepoerViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PatientRepoerViewController: UIViewController {

    @IBOutlet weak var pname: UILabel!
    @IBOutlet weak var phight: UILabel!
    @IBOutlet weak var pwight: UILabel!
    @IBOutlet weak var pmobile: UILabel!
    @IBOutlet weak var pmedicalHistry: UILabel!

    
    
    
    var product: Patients?
    var selecteduserid=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pname.text=product?.patien_name

        let databaseReference = Database.database().reference()
            self.title="Patient"
            let uid = product?.patien_id
            databaseReference.child("Users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() { return }
                print(snapshot) // Its print all values including Snap (User)
                print(snapshot.value!)
                let nawight = snapshot.childSnapshot(forPath: "Wight").value as! String
                let nhight = snapshot.childSnapshot(forPath: "Hight").value as! String
                let mobileFB = snapshot.childSnapshot(forPath: "Mobile").value as! String
                let medHistoryFB = snapshot.childSnapshot(forPath: "medicalHistory").value as! String
                self.phight.text = nawight
                self.pwight.text = nhight
                self.pmobile.text = mobileFB
                self.pmedicalHistry.text = medHistoryFB
                self.selecteduserid = snapshot.childSnapshot(forPath: "ID").value as! String
            })
        
    }
    var post = [:] as [String : Any]
    @IBAction func active(_ sender: Any) {
        let alertController = UIAlertController(title: "Active", message: "user now is active.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.post = [
                "statue" :  "True"
            ]
            Database.database().reference().child("Users").child(self.selecteduserid).updateChildValues(self.post)
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
