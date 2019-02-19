//
//  ItemVC.swift
//  SwiftyChecklist
//
//  Created by Ankit Saxena on 20/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit

class ItemVC: UITableViewController {
    
    var itemArray = [itemModel]()
    var userDefault = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.pList")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        itemArray[indexPath.row].done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
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
            let item = itemModel()
            item.title = itemTextField.text!
            item.done = false
            self.itemArray.append(item)
            
            //Encoding and Storing Data
            self.saveData()
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.filePath!)
        }
        catch{
            print(error)
        }
    }
    
    func loadData(){
        do{
            let data = try Data(contentsOf: filePath!)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([itemModel].self, from: data)
            print("Data Loaded!")
        }
        catch{
            print(error)
        }
        self.tableView.reloadData()
    }
}
