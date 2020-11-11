//
//  HomeViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//
import UserNotifications
import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @objc func notification() {

        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let _ : UserTasks = userTasks.map{ task in
            guard let stringDate = task.taskDate,
                  let  dueDate = self.formatter().date(from: stringDate),
                  Date().addingTimeInterval(3600) < dueDate else {
                return task
            }
            notifications.scheduleNotification(dueDate: dueDate, taskTitle: task.taskName)
            return task
        }
       
    }
    
    let notifications = Notifications()
    var userTasks = UserTasks()
    var completed = UserTasks()
    var uncompleted = UserTasks()
    var userTasksArray = UserTasks()
    var cell = TableViewCell()
    
    let name: String = UserDefaults.standard.string(forKey: "name") ?? ""
    var dataFilter = 1
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        childView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        userName.text = name
        tableView.dataSource = self
        tableView.delegate = self
        listTasks()
        addRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification), name: NSNotification.Name(rawValue: "sendNotif"), object: nil)
        
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
                self.uncompleted = self.userTasks.filter { $0.isCompleted == "0" }
                self.completed = self.userTasks.filter { $0.isCompleted == "1" }
                print(self.userTasks)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func switchFilter(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dataFilter = 0
            print("dataFilter = 0")
        case 1:
            dataFilter = 1
            print("dataFilter = 1")
        case 2:
            dataFilter = 2
            print("dataFilter = 2")
        default:
            return
        }
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch dataFilter {
        case 0:
            returnValue = self.uncompleted.count
        case 1:
            returnValue = self.userTasks.count
        case 2:
            returnValue = self.completed.count
        default:
            return 0
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        switch dataFilter {
                case 0:
                   userTasksArray  = uncompleted
                case 1:
                    userTasksArray = userTasks
                case 2:
                    userTasksArray = completed
                default:
                   userTasksArray  = userTasks
            }
        
        let taskRow = userTasksArray[indexPath.row]
        cell.index = indexPath.row
        cell.cellDelegate = self
        cell.taskTitle.text = taskRow.taskName
        
        if taskRow.taskDate != nil {
            if taskRow.isCompleted == "0" {
//                var timeRemaining: String {
//                    guard let taskDate = taskRow.taskDate else { return "" }
//                    let date = self.formatter().date(from: (taskDate))
//                    return Date().timeRemain(until: date!)!
//                }
//                print(timeRemaining)
                cell.dueDateLabel.text = checkRemaining(taskDueDate: taskRow.taskDate!)
            } else {
                cell.dueDateLabel.text = "completed"
            }
        } else {
            cell.dueDateLabel.text = ""
        }
        
        if taskRow.isCompleted == "1" {
            cell.checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.taskTitle.strikeThrough(true)
            
        } else if taskRow.isCompleted == "0" {
            cell.checkButton.setImage(nil, for: .normal)
            cell.taskTitle.strikeThrough(false)
        }
        return cell
    }
}
    
    // MARK: - UITableViewDelegate
    extension HomeViewController: UITableViewDelegate {
        
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tasks"
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = indexPath.row
        let id = self.userTasksArray[index].taskID
        let isCompleted = self.userTasksArray[index].isCompleted
        
        let isCompeleteAction = UIContextualAction(style: .normal, title: "",
            handler: { (action, view, completionHandler) in
                
                print("id: \(id)")
                if isCompleted == "0" {
                    TaskAPI.isComplete(taskID: id, isCompleted: true) { (success) in
                        if success {
                            print("task has been updated successfully")
                            self.listTasks()
                        }
                    }
                } else if isCompleted == "1" {
                    TaskAPI.isComplete(taskID: id, isCompleted: false) { (success) in
                        if success {
                            print("task has been updated successfully")
                            self.listTasks()
                        }
                    }
                }
                completionHandler(true)
          })
        
        if isCompleted == "0" {
            isCompeleteAction.backgroundColor = #colorLiteral(red: 0.5886604786, green: 0.5875415206, blue: 0.7572305799, alpha: 1)
            isCompeleteAction.image = UIImage(systemName: "checkmark")
        } else {
            isCompeleteAction.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            isCompeleteAction.image = UIImage(systemName: "xmark")
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [isCompeleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
       let index = indexPath.row
       let id = self.userTasksArray[index].taskID

       let deleteAction = UIContextualAction(style: .normal, title: "",
           handler: { (action, view, completionHandler) in
            
               print("id: \(id)")
               TaskAPI.deleteTask(taskID: id) { (success) in
                   if success {
                       print("task has been deleted successfully")
                    self.listTasks()
                   }
               }
               completionHandler(true)
         })
        
       deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.2210419178, blue: 0.3287946582, alpha: 1)
       deleteAction.image = UIImage(systemName: "trash")
       
       let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
       
       return configuration
   }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.cellPadding(cell: cell, x: 10, y: 6)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "taskDetails":
            if let des = segue.destination as? TaskDetailsViewController {
                let row = tableView.indexPathForSelectedRow?.row
                des.task = userTasksArray[(row)!]
                des.delegate = self
            }
        case "createTask" :
            if let des = segue.destination as? TaskViewController {
                des.delegate = self
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}


extension HomeViewController: TaskCellDelegate {
    func updateTask(index: Int) {
        
        
        let id = userTasksArray[index].taskID
        print("protocol Index: \(id)")
        if self.userTasksArray[index].isCompleted == "0" {
            TaskAPI.isComplete(taskID: id, isCompleted: true) { (success) in
                if success {
                    print("task has been updated successfully")
                    self.listTasks()
                }
            }
        } else if self.userTasksArray[index].isCompleted == "1" {
            TaskAPI.isComplete(taskID: id, isCompleted: false) { (success) in
                if success {
                    print("task has been updated successfully")
                    self.listTasks()
                }
            }
        }
    }
}

extension HomeViewController: updateTable {
    
    func handleUpdate() {
        listTasks()
    }
}
