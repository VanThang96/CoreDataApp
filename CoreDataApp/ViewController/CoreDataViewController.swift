//
//  CoreDataViewController.swift
//  CoreDataApp
//
//  Created by win on 3/23/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit
import CoreData


class CoreDataViewController: UIViewController {

    var resultsController : NSFetchedResultsController<CoreData>!
    let coreDataStack = CoreDataStack()
    
    @IBOutlet weak var coreDataTableView: CoreDataTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Request
        let request : NSFetchRequest<CoreData> = CoreData.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        //init
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(fetchRequest: request,
                                                       managedObjectContext:coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        resultsController.delegate = self
        //fetch
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch erroe : \(error)")
        }
    }
    

}
extension CoreDataViewController : UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)   as? AddTableViewCell
        let coreData = resultsController.object(at: indexPath)
        cell?.labelTitle.text = coreData.title
        return cell!
    }
    
   func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit", handler: {(action,view,completion) in
            //delete data
            let coreData = self.resultsController.object(at: indexPath)
            coreData.title = "aaa"
            coreData.priotity = Int16(11)
            coreData.date = Date()
            do {
                try self.resultsController.managedObjectContext.save()
            } catch{
                print("Error delete coreData : \(error)")
            }
            completion(true)
        })
        action.image    =   UIImage(named: "Edit")
        action.backgroundColor  =   .green
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {(action,view,completion) in
            //delete data
            let coreData = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(coreData)
            do {
                try self.resultsController.managedObjectContext.save()
            } catch{
                print("Error delete coreData : \(error)")
            }
            completion(true)
        })
        action.image    =   UIImage(named: "Trash")
        action.backgroundColor  =   .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem , let vc = segue.destination as? AddViewController{
            vc.managerContext = resultsController.managedObjectContext
        }
        if let cell = sender as? AddTableViewCell, let vc = segue.destination as? AddViewController {
            vc.managerContext = resultsController.managedObjectContext
            if let index = coreDataTableView.indexPath(for: cell){
                let coreData = resultsController.object(at: index)
                vc.coreData = coreData
            }
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        coreDataTableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        coreDataTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexpath = newIndexPath{
                coreDataTableView.insertRows(at: [indexpath], with: .automatic)
            }
        case .delete:
            if let indexpath = indexPath{
                coreDataTableView.deleteRows(at: [indexpath], with: .automatic)
            }
        case .update:
                //coreDataTableView.reloadData()
            if let indexpath = indexPath, let cell = coreDataTableView.cellForRow(at: indexpath) as? AddTableViewCell{
                let coreData = resultsController.object(at: indexpath)
                cell.labelTitle.text = coreData.title
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAddCoreData", sender: coreDataTableView.cellForRow(at: indexPath))
    }
}
