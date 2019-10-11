//
//  CheckUpsDVC.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 3/30/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialTextFields

extension UIViewController
{
    func HideKeyboard()
    {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Dismisskeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func Dismisskeyboard()
    {
        view.endEditing(true)
    }
}

class CheckUpsDVC: UIViewController {
    
    @IBOutlet weak var TnameodD: UILabel!
    @IBOutlet weak var TvalueofV: UILabel!
    @IBOutlet weak var TvalueofV2: UILabel!
    @IBOutlet weak var TMecHistory: UILabel!
    @IBOutlet weak var hight: UILabel!
    @IBOutlet weak var wight: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var replayText: MDCTextField!
    
    
    var product: Feeds?
    var post = [:] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let nameodD =
        TnameodD.text =  product?.patien_name
        TvalueofV.text =  "pressure: " + (product?.value)!
        TvalueofV2.text =  "sugar: " + (product?.value2)!
        TnameodD.text =  "Details"
        
        let pid = product?.pid
        
        //print(nameodD!)
        
        let databaseReference = Database.database().reference()
        databaseReference.child("Users").child(pid!).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            print(snapshot) // Its print all values including Snap (User)
            print(snapshot.value!)
            let mhFB = snapshot.childSnapshot(forPath: "medicalHistory").value as! String
            self.hight.text = snapshot.childSnapshot(forPath: "Hight").value as? String
            self.wight.text = snapshot.childSnapshot(forPath: "Wight").value as? String
            self.TMecHistory.text = mhFB
        })
        
        self.HideKeyboard()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    @objc func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollview.contentInset = contentInsets
            self.scrollview.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
    }


    // Keyboard
    
    // Keyboared
    @IBAction func submit(_ sender: Any)
    {
        let nid = Auth.auth().currentUser?.uid
        post = [
            "NurseId": nid!,
            "Comment": replayText.text ?? "call us please.",
            "Statue": "replyed"
        ]
        Database.database().reference().child("Vitals").child((product?.id)!).updateChildValues(post)
        _ = navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @objc func NameOfSelector(notification:Notification) {
//
//        let userInfo = notification.userInfo!
//
//        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
//
//        if notification.name == Notification.Name.UIKeyboardWillHide
//        {
//            scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardScreenEndFrame.height, right: 0)
//        }
//        else
//        {
//            scrollview.scrollIndicatorInsets = scrollview.contentInset
//        }
//    }
}

