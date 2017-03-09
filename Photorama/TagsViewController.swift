//
//  TagsViewController.swift
//  Photorama
//
//  Created by Dylan Bruschi on 3/6/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class TagsViewController: UITableViewController {
    
    // MARK: Declarations
    
    var store: PhotoStore!
    var photo: Photo!
    
    var selectedIndexPaths = [NSIndexPath]()
    
    let tagDataSource = TagDataSource()
    
    // MARK: Button actions
    
    @IBAction func done(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewTag(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Tag", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            
            textField.placeholder = "tag name"
            textField.autocapitalizationType = .words
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if let tagName = alertController.textFields?.first!.text {
                let context = self.store.coreDataStack.mainQueueContext
                let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context)
                newTag.setValue(tagName, forKey: "name")
                
                do {
                    try self.store.coreDataStack.saveChanges()
            }
                catch let error {
                    print("Core data save failed: \(error)")
                    
                }
                self.updateTags()
                self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            }
        })
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
 
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tagDataSource
        tableView.delegate = self
        
        updateTags()
    }
    
    func updateTags() {
        let tags = try! store.fetchMainQueueTags(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        tagDataSource.tags = tags
        
        for tag in tags {
            if let index = tagDataSource.tags.index(of: tag) {
                let indexPath = NSIndexPath(row: index, section: 0)
                selectedIndexPaths.append(indexPath)
            }
        }
    }
    
    // MARK: Table view methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = tagDataSource.tags[indexPath.row]
        
        if let index = selectedIndexPaths.index(of: indexPath as NSIndexPath) {
            selectedIndexPaths.remove(at: index)
            photo.removeTagObject(tag: tag)
        }
            
        else {
            selectedIndexPaths.append(indexPath as NSIndexPath)
            photo.removeTagObject(tag: tag)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        do {
            try store.coreDataStack.saveChanges()
        }
        catch let error {
            print("Core Data save failed: \(error)")
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedIndexPaths.index(of: indexPath as NSIndexPath) != nil {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
    }
}
