//
//  getirTableView.swift
//  GetirTodo
//
//  Created by Furkan Yıldız on 18.09.2021.
//

import UIKit
import CoreData

var getirList = [ToDo] ()
let vc = getirDetailVC ()

class getirTableView: UITableViewController {
    
    var firstLoad = true
    
    func nonDeletedToDos() -> [ToDo] {
        
        var noDeleteToDoList = [ToDo]()
        
        for todo in getirList {
            if (todo.deletedDate == nil) {
                noDeleteToDoList.append(todo)
            }
        }
        return noDeleteToDoList
    }
    
    override func viewDidLoad() {
        
        if (firstLoad) {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
            
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let todo = result as! ToDo
                    getirList.append(todo)
                }
            } catch {
                print("Fetch failed")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let getirCellCell = tableView.dequeueReusableCell(withIdentifier: "getirCellID", for: indexPath) as! getirCell
        
        let selectToDo: ToDo!
        selectToDo = nonDeletedToDos()[indexPath.row]
        
        getirCellCell.titleLabel.text = selectToDo.title
        
        return getirCellCell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nonDeletedToDos().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editToDo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editToDo") {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let getirDetail = segue.destination as? getirDetailVC
            
            let selectedToDo : ToDo!
            selectedToDo = nonDeletedToDos()[indexPath.row]
            getirDetail?.selectedToDo = selectedToDo
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        

        let getir = nonDeletedToDos()[indexPath.row]
        if editingStyle == .delete {
            getirList.remove(at: indexPath.row)
            context.delete(getir as NSManagedObject)
            
            do {
                
                try context.save()

            } catch
            let error as NSError {
                print("Could not save. \(error),\(error.userInfo)")
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    

}
