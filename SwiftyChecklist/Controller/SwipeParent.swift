//
//  SwipeParent.swift
//  SwiftyChecklist
//
//  Created by Ankit Saxena on 21/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeParent: UITableViewController, SwipeTableViewCellDelegate {
    var currentIndexPath : IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.currentIndexPath = indexPath
            self.deleteAction()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    //MARK: Override These Functions ONLY
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func deleteAction() {
    }

}
