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
    var cell = TableViewCell()
    var taskId = 0
    var headerTitles = ["Tasks", "Completed"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        userName.text = name
        tableView.dataSource = self
        tableView.delegate = self
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
//
    @IBAction func tickButtonn(_ sender: UIButton) {
//        let row = tableView.indexPathForSelectedRow?.row
//        let id = userTasks[(row)!].taskID
        if sender.tag == 1 {
            sender.backgroundColor = .offWhite
            sender.tag = 0
            sender.isSelected = false
            print(sender.tag)
//            print("sender.isSelected: \(cell.isSelected)")
            TaskAPI.isComplete(taskID: taskId, isCompleted: false) { (success) in
                if success {
//                    sender.backgroundColor = .offWhite
//                    sender.tag = 0
//                    sender.isSelected = false
                }
            }
            
        } else if sender.tag == 0 {
                        sender.backgroundColor = .purple
                        sender.tag = 1
                        sender.isSelected = true
            print(sender.tag)
            TaskAPI.isComplete(taskID: taskId, isCompleted: true) { (success) in
                if success {
//                    sender.backgroundColor = .purple
//                    sender.tag = 1
//                    sender.isSelected = true
                }
                //            print("sender.isSelected: \(cell.isSelected)")
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
        taskId = taskRow.taskID
        print(taskId)
        cell.taskTitle.text = taskRow.taskName
        
        if taskRow.taskDate != nil {
            let now = Date()
            let dueDateString = taskRow.taskDate
            let fo = DateFormatter()
            fo.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dueDate = fo.date(from: dueDateString!)!
            let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: now, to: dueDate)
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
            
        } else {
            cell.dueDateLabel.text = ""
        }
        
        if taskRow.isCompleted == "1" {
            cell.checkButton.backgroundColor = .purple
            cell.checkButton.isSelected = true
            cell.checkButton.tag = 1
            cell.taskTitle.strikeThrough(true)
            
        } else if taskRow.isCompleted == "0" {
            cell.checkButton.backgroundColor = .offWhite
            cell.checkButton.isSelected = false
            cell.checkButton.tag = 0
            cell.taskTitle.strikeThrough(false)
        }
        
//        cell.taskTitle.strikeThrough(cell.checkButton.isSelected)
//        print("cell.checkButton.isSelected: \(cell.checkButton.isSelected)")

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

        let deleteAction = UIContextualAction(style: .normal, title: "",
            handler: { (action, view, completionHandler) in
//                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("id: \(id)")
                TaskAPI.deleteTask(taskID: id) { (success) in
                    if success {
                        print("task has been deleted successfully")
//                        self.tableView.reloadData()
                        #warning("Stupid way to reload table -need to get back to it-")
                        let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "home")
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        mainTabBarController.modalTransitionStyle = .crossDissolve
                        self.present(mainTabBarController, animated: true, completion: nil)
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
