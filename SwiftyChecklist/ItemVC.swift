//
//  ItemVC.swift
//  SwiftyChecklist
//
//  Created by Ankit Saxena on 20/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit

class ItemVC: UITableViewController {
    
    var itemArray = ["First", "Second", "Third", "Fourth"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (localTextField) in
            localTextField.placeholder = "Item Name"
            itemTextField = localTextField
        }
        let action = UIAlertAction(title: "Enter the name of Item!", style: .default) { (action) in
            self.itemArray.append(itemTextField.text!)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
