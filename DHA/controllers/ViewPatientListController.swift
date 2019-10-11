//
//  ViewPatientListController.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 2/11/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewPatientListController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    var patients: [Patients] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Patints List"
        createArray()
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    func createArray()
    {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        var cells: [Patients] = []
        let databaseReference = Database.database().reference()
        databaseReference.child("Users").queryOrdered(byChild: "Access").queryEqual(toValue: "Patient").observe( .value, with: { (snapshot) in
            self.present(alert, animated: true, completion: nil)
            self.patients.removeAll()
            cells.removeAll()
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let childVal = child.value as? [String: AnyObject] {
                    let recored1 = Patients(patien_id: childVal["ID"] as! String,patien_name: childVal["Name"] as! String, patien_gender: #imageLiteral(resourceName: "Profile"))
                    cells.append(recored1)
                }
            }
            self.patients = cells.reversed()
            self.TableView.reloadData()
            alert.dismiss(animated: false, completion: nil)
        }
        )
    }
}
extension ViewPatientListController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let patient = patients[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TablePatientListCell
        
        cell.setList(patient:patient)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "PatientRepoerViewController") as? PatientRepoerViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PatientRepoerViewController {
            destination.product = patients[(TableView.indexPathForSelectedRow?.row)!]
            TableView.deselectRow(at: TableView.indexPathForSelectedRow!, animated: true)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
