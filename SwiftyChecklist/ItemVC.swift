//
//  ItemVC.swift
//  SwiftyChecklist
//
//  Created by Ankit Saxena on 20/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit
import CoreData

class ItemVC: UITableViewController {
    
    var itemArray = [ItemModel]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var globalSearchBar = UISearchBar()
    var selectCat : CatModel? {
        didSet{
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            let item = ItemModel(context: self.context)
            item.title = itemTextField.text!
            item.done = false
            item.parentCat = self.selectCat
            self.itemArray.append(item)
            //Storing Data
            self.saveData()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func saveData(){
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<ItemModel> = ItemModel.fetchRequest(), addPredicate : NSPredicate? = nil){
        print("loadData Called")
        let catPredicate = NSPredicate(format: "parentCat.title MATCHES[cd] %@", selectCat!.title!)
        if let newPredicate = addPredicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, newPredicate])
            request.predicate = compoundPredicate
        }
        else{
            request.predicate = catPredicate
        }
        
        do{
           itemArray =  try context.fetch(request)
        }
        catch{
            print(error)
        }
        self.tableView.reloadData()
    }
}

extension ItemVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text! == ""{
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadData()
        }
        else{
            let request : NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadData(with: request)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == ""{
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadData()
        }
    }
    
}
