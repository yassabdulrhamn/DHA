//
//  FeedsViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FeedsViewController: UIViewController {
    
    var feeds: [Feeds] = []
    @IBOutlet weak var TableView: UITableView!
    let databaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Checkups"
        createArray()
        TableView.delegate = self
        TableView.dataSource = self
        
    }
    
    var pname="Patient name";
    func createArray()
    {

        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        var cells: [Feeds] = []
        databaseReference.child("Vitals").queryOrdered(byChild: "Statue").queryEqual(toValue: "New").observe( .value, with: { (snapshot) in
            
            if(self.feeds.count<1)
            {
                self.present(alert, animated: true, completion: nil)
            }
            
            self.feeds.removeAll()
            cells.removeAll()
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let childVal = child.value as? [String: AnyObject] {

                    var com = childVal["Comment"] as! String
                    if(com == "false" || com == "")
                    {

                        let recored1 = Feeds(patien_name: "Blood Pressure",value: childVal["BloodPressure"] as! String, patien_name2: "Blood Sugar",value2: childVal["BloodSugar"] as! String, date: childVal["DateEntered"] as! String, comment: com, id: child.key, pid: childVal["PatientID"] as! String)
                        cells.append(recored1)
                        
//                        let BS = childVal["BloodSugar"] as! String
//                        if(BS != "false" && BS != "")
//                        {
//                            print("BloodPressure:")
//                            let recored1 = Feeds(patien_name: "Blood Sugar", value: childVal["BloodSugar"] as! String, date: childVal["DateEntered"] as! String, comment: com, id: child.key, pid: childVal["PatientID"] as! String)
//                            cells.append(recored1)
//                        }
                    }
                    else
                    {
                        
                    }
                }
            }
            self.feeds = cells.reversed()
            self.TableView.reloadData()
            alert.dismiss(animated: false, completion: nil)
        }
        )
    }
//    func getName(x:String) -> String
//    {
//        print(" X: ")
//        print(x)
//        var nameVar = "Luffy"
//        self.databaseReference.child("Users").child(x).observeSingleEvent(of: .value, with: { snapshot in
//            if !snapshot.exists() { return }
//            print(snapshot) // Its print all values including Snap (User)
//            print(snapshot.value!)
//            print("return:")
//            //print(snapshot.childSnapshot(forPath: "Name").value as! String)
//            nameVar = snapshot.childSnapshot(forPath: "Name").value as! String
//        })
//        return nameVar
//    }
//
//
//    func downloadCats(completion: @escaping () -> Void) {
//        self.databaseReference.child("Users").child("").observeSingleEvent(of: .value, with: { snapshot in
//            if !snapshot.exists() { return }
//            print(snapshot) // Its print all values including Snap (User)
//            print(snapshot.value!)
//            print("return:")
//            print(snapshot.childSnapshot(forPath: "Name").value as! String)
//             completion()
//        })
//    }

}

extension FeedsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = feeds[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! TableFeedCell
        
        cell.setFeed(feed:feed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = storyboard?.instantiateViewController(withIdentifier: "PatientRepoerViewController") as? PatientRepoerViewController
        //        self.navigationController?.pushViewController(vc!, animated: true)
        performSegue(withIdentifier: "checkupsD", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CheckUpsDVC {
            destination.product = feeds[(TableView.indexPathForSelectedRow?.row)!]
            TableView.deselectRow(at: TableView.indexPathForSelectedRow!, animated: true)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
