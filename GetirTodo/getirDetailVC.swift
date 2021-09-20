//
//  ViewController.swift
//  GetirTodo
//
//  Created by Umut Afacan on 21.12.2020.
//

import UIKit
import CoreData

class getirDetailVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var selectedToDo : ToDo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if(selectedToDo != nil) {
            titleTextField.text = selectedToDo?.title
            descriptionTextField.text = selectedToDo?.desc
        }
    }

    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        if(selectedToDo == nil) {
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: context)
        let newToDo = ToDo(entity: entity!, insertInto: context)
        
        newToDo.id = getirList.count as NSNumber
        newToDo.title = titleTextField.text
        newToDo.desc = descriptionTextField.text
        
        do {
            if titleTextField.text != "" && descriptionTextField.text != "" {
            try context.save()
            getirList.append(newToDo)
                navigationController?.popViewController(animated: true) }
            
        } catch {
            print("Data save error")
        }
    }
        else  { //edit
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
            
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let todo = result as! ToDo
                    
                    if(todo == selectedToDo) {
                        todo.title = titleTextField.text
                        todo.desc = descriptionTextField.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let todo = result as! ToDo
                
                if(todo == selectedToDo) {
                    todo.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    
        
    }
    
   
    
    
}

