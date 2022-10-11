//
//  TableViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [Student]()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPins()
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        getPins()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        Client.logout { success, error in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            } else {
                if let error = error {
                    self.showAlert(title: "Error logout", message: error.localizedDescription)
                }
            }
        }
    }
    
    func getPins() {
        Client.getAllLocations { students, error in
            if students.count == 0 {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            } else {
                self.students = students
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = students[indexPath.row].firstName ?? ""
        cell.detailTextLabel?.text = students[indexPath.row].mediaURL ?? ""

        return cell
    }
}
