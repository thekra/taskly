//
//  TaskDetailsViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    @IBOutlet weak var taskTitleTF: UITextField!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    
    var formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    
    var selectedDate = ""
    var task: UserTask?
    var note = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        taskTitleTF.text = task?.taskName
        noteTV.text = task?.comment
        print(task?.taskDate as Any)
        
        if task?.taskDate != nil {
        dueDateSwitch.isOn = true
        datepicker.isHidden = false
        
        let date = formatter.date(from: (task?.taskDate)!)!
        datepicker.date = date
        } else {
            dueDateSwitch.isOn = false
            datepicker.isHidden = true
        }
//        dueDate()
        print("taskID: \((task?.taskID))")
    }
    
    func setupUI() {
        taskTitleTF.layer.cornerRadius = 10
        noteTV.layer.cornerRadius = 13
        doneButton.layer.cornerRadius = 13
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        #warning("Need some modification")
        if task?.taskName == taskTitleTF.text {
            print("task name has not changed")
        }
        
        if taskTitleTF.text == "" {
            print("can't leave task title empty")
        }
        
        if task?.comment == noteTV.text {
            print("task notes has not changed")
        }
        
        TaskAPI.updateTask(taskID: (task?.taskID)!,
                           taskTitle: taskTitleTF.text!,
                           taskDate: selectedDate,
                           comment: noteTV.text) { (success) in
            if success {
                print("Saved")
//                self.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "home")
                mainTabBarController.modalPresentationStyle = .fullScreen
                mainTabBarController.modalTransitionStyle = .crossDissolve
                self.present(mainTabBarController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dueDateSwitcher(_ sender: UISwitch) {
        if sender.isOn {
            datepicker.isHidden = false
            selectedDate = formatter.string(from: datepicker.date)
        } else {
            datepicker.isHidden = true
            selectedDate = ""
        }
    }
}

