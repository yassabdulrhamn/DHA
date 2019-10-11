//
//  RecordsViewController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RecordsViewController: UIViewController {

    var records: [Recoreds] = []
    @IBOutlet weak var TableView: UITableView!
    let databaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createArray()
        TableView.delegate = self
        TableView.dataSource = self
        
        TableView.rowHeight = UITableView.automaticDimension
        TableView.estimatedRowHeight = 44
        TableView.reloadData()
    }
    func createArray()
    {
     
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        let uID = Auth.auth().currentUser?.uid
        var cells: [Recoreds] = []
        databaseReference.child("Vitals").queryOrdered(byChild: "PatientID").queryEqual(toValue: uID).observe( .value, with: { (snapshot) in
            self.present(alert, animated: true, completion: nil)
            self.records.removeAll()
            cells.removeAll()
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let childVal = child.value as? [String: AnyObject] {

                    let recored1 = Recoreds(title: "Blood Presser", value: childVal["BloodPressure"] as! String, title2: "Blood Sugar", value2: childVal["BloodSugar"] as! String, date: childVal["DateEntered"] as! String, reply: childVal["Comment"] as! String)
                    cells.append(recored1)

                }
            }
            self.records = cells.reversed()
            self.TableView.reloadData()
            alert.dismiss(animated: false, completion: nil)
        }
        )
    }
    

}
extension RecordsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = records[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell") as! TableRecordsCell
        
        cell.setRecored(record: record)
        return cell
    }
}


