//
//  CatVC.swift
//  SwiftyChecklist
//
//  Created by Ankit Saxena on 21/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit
import CoreData

class CatVC: UITableViewController {
    
    var catArray = [CatModel]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCat()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = catArray[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Catery Name"
            localTextField = textField
        }
        let action = UIAlertAction(title: "Enter the name of Category", style: .default) { (action) in
            let item = CatModel(context: self.context)
            item.title = localTextField.text!
            self.catArray.append(item)
            self.saveCat()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func saveCat(){
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCat(){
        let request : NSFetchRequest<CatModel> = CatModel.fetchRequest()
        do{
           catArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }


}
