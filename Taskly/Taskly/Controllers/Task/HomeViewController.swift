//
//  HomeViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var childView: UIView!
    var checked = [[Int(),Int()]]
    let name: String = UserDefaults.standard.string(forKey: "name")!
    @IBOutlet weak var userName: UILabel!
    var userTasks = UserTasks()
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    var refreshControl: UIRefreshControl?
    var cell = TableViewCell()
    var headerTitles = ["Tasks", "Completed"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTasks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        userName.text = name
        tableView.dataSource = self
        tableView.delegate = self
        listTasks()
        addRefresh()
    }
    
    func addRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshlist), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshlist() {
        refreshControl?.endRefreshing()
        listTasks()
    }
    
    func listTasks() {
        TaskAPI.listTasks { (UserTask, success) in
            if success {
                self.userTasks = UserTask
                print(self.userTasks)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userTasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let taskRow = userTasks[indexPath.row]
        cell.index = indexPath.row
        cell.cellDelegate = self
        cell.taskTitle.text = taskRow.taskName
        
        if taskRow.taskDate != nil {
            let now = Date()
            let dueDateString = taskRow.taskDate
            let fo = DateFormatter()
            fo.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dueDate = fo.date(from: dueDateString!)!
            let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: dueDate)
            //let days = diffComponents.day
            let hours = diffComponents.hour
            let mins = diffComponents.minute

            if hours! < 0 {
                cell.dueDateLabel.text = "Due date has passed \(abs(hours!)) hours ago"
            } else {
                cell.dueDateLabel.text = "Due date is in \(hours!) hour"
            }
            
            if hours == 0 {
                if mins! > 0 {
                    cell.dueDateLabel.text = "Due date is in \(mins!) mins"
                } else {
                    cell.dueDateLabel.text = "Due date has passed \(abs(mins!)) mins ago"
                }
            }
            
//            if hours! > 24 {
//                if days! > 0 {
//                    cell.dueDateLabel.text = "Due date is in \(days!) mins"
//                } else {
//                    cell.dueDateLabel.text = "Due date has passed \(abs(days!)) mins ago"
//                }
//            }
            
        } else {
            cell.dueDateLabel.text = ""
        }
        
        if taskRow.isCompleted == "1" {
            cell.checkButton.backgroundColor = .purple
            cell.taskTitle.strikeThrough(true)
            
        } else if taskRow.isCompleted == "0" {
            cell.checkButton.backgroundColor = .offWhite
            cell.taskTitle.strikeThrough(false)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return headerTitles[0]
        case 1:
            return headerTitles[1]
        default:
            return ""
        }
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = indexPath.row
        let id = self.userTasks[index].taskID

        let isCompeleteAction = UIContextualAction(style: .normal, title: "",
            handler: { (action, view, completionHandler) in
                
                print("id: \(id)")
                if self.userTasks[index].isCompleted == "0" {
                TaskAPI.isComplete(taskID: id, isCompleted: true) { (success) in
                    if success {
                        print("task has been updated successfully")
                        self.listTasks()
                    }
                }
                } else if self.userTasks[index].isCompleted == "1" {
                    TaskAPI.isComplete(taskID: id, isCompleted: false) { (success) in
                        if success {
                            print("task has been updated successfully")
                            self.listTasks()
                        }
                    }
                }
                completionHandler(true)
          })
        
        isCompeleteAction.backgroundColor = #colorLiteral(red: 0.5886604786, green: 0.5875415206, blue: 0.7572305799, alpha: 1)
        isCompeleteAction.image = UIImage(systemName: "checkmark")
        
        let configuration = UISwipeActionsConfiguration(actions: [isCompeleteAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
       let index = indexPath.row
       let id = self.userTasks[index].taskID

       let deleteAction = UIContextualAction(style: .normal, title: "",
           handler: { (action, view, completionHandler) in
//                tableView.deleteRows(at: [indexPath], with: .automatic)
               print("id: \(id)")
               TaskAPI.deleteTask(taskID: id) { (success) in
                   if success {
                       print("task has been deleted successfully")
                   }
               }
           
               completionHandler(true)
         })
        self.listTasks()
       deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.2210419178, blue: 0.3287946582, alpha: 1)
       deleteAction.image = UIImage(systemName: "trash")
       
       let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
       
       return configuration
   }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            let maskLayer = CALayer()
            maskLayer.cornerRadius = 20
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 10, dy: 6)
            cell.layer.mask = maskLayer
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "taskDetails":
            if let des = segue.destination as? TaskDetailsViewController {
                let row = tableView.indexPathForSelectedRow?.row
                des.task = userTasks[(row)!]
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}


extension HomeViewController: TaskCellDelegate {
    func updateTask(index: Int) {
        
        
        let id = userTasks[index].taskID
        print("protocol Index: \(id)")
        if self.userTasks[index].isCompleted == "0" {
            TaskAPI.isComplete(taskID: id, isCompleted: true) { (success) in
                if success {
                    print("task has been updated successfully")
                    self.listTasks()
                }
            }
        } else if self.userTasks[index].isCompleted == "1" {
            TaskAPI.isComplete(taskID: id, isCompleted: false) { (success) in
                if success {
                    print("task has been updated successfully")
                    self.listTasks()
                }
            }
        }
//        listTasks()
    }
}
