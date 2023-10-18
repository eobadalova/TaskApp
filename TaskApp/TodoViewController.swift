import UIKit

// simple model class for Task data entity
final class Task {
    var name: String?
    var description: String?
    
    // to generate some example tasks
    static func generateTasks (_ count: Int) -> [Task] {
        var tasks: [Task] = []
        for i in 1...count {
            let task = Task()
            task.name = "Task \(i)"
            task.description = "Description of task #\(i)"
            tasks.append(task)
        }
        return tasks
    }
}


class TodoViewController: UITableViewController {
    
    // generate tasks
    var tasks: [Task] = Task.generateTasks(10)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todo App"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set the tab bar item to the root navigation controller
        super.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonTapped))
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item
        let selectedItem = tasks[indexPath.row]
        
        // Perform the segue with identifier and pass data
        performSegue(withIdentifier: "goToDetail", sender: selectedItem)
    }
    
    // Specify editing style (delete in this case)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Actions
    
    @objc func addTaskButtonTapped() {
        let alertController = UIAlertController(title: "Add Task", message: "Add a new task for today", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter task"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter description"
        }
        
    
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            let taskItem = Task()
            
            if let taskName = alertController.textFields?.first?.text, !taskName.isEmpty {
                if let taskDescription = alertController.textFields?.last?.text, !taskDescription.isEmpty{
                    taskItem.name = taskName
                     taskItem.description = taskDescription
                     self?.tasks.append(taskItem)
                }

                
                
            }
            

            
           
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
   // set the selected Task object as the property of destination VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "goToDetail" {
            if let destinationVC = segue.destination as? DetailViewController {
               if let selectedItem = sender as? Task {
                  destinationVC.taskObj = selectedItem
                }
                
           }
       }
}
    
}
