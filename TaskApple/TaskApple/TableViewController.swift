//
//  ViewController.swift
//  TaskApple
//
//  Created by User on 09.02.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    
    var tasks:[Tasks] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest:NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDesctiptor]
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    private func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.yellow]
    }
    

    @IBAction func saveText(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New task", message: "Pleale add to new task", preferredStyle: .alert)
        alert.addTextField()
        let saveAction = UIAlertAction(title: "Save", style: .default) {[weak self] action in
            guard let textField = alert.textFields?.first else {return}
            if let newTaskTitle =  textField.text{
                self?.saveTask(withTitle: newTaskTitle)
                //self?.tasks.insert(task, at: 0)
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    @IBAction func deleteTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete tasks?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) {[weak self] action in
            let context = self?.getContext()
            let fetchRequest:NSFetchRequest<Tasks> = Tasks.fetchRequest()
            
            
            if let objects = try? context?.fetch(fetchRequest){
                for obj in objects{
                    context?.delete(obj)
                    //self?.tasks.removeAll()
                    self?.tableView.reloadData()
                }
            }
            self?.saveContext(context!)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true)
    }
    func saveContext(_ context:NSManagedObjectContext){
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    private func saveTask(withTitle title:String){
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.textLabel?.textColor = UIColor.yellow
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let context = getContext()
            let task = tasks[indexPath.row]
            
            let fetchRequest:NSFetchRequest<Tasks> = Tasks.fetchRequest()
            if let objects = try? context.fetch(fetchRequest){
                for obj in objects{
                    if task.title == obj.title{
                        context.delete(obj)
                        tableView.reloadData()
                    }
                }
            }
            
            saveContext(context)
        }
    }
}

