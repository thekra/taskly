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
    
    
    var selectedDate = ""
    var task: UserTask?
    var homeInstance : HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        taskTitleTF.text = task?.taskName
        noteTV.text      = task?.comment
        print(task?.taskDate as Any)
        
        if task?.taskDate != nil {
        dueDateSwitch.isOn  = true
        datepicker.isHidden = false
        let date = self.formatter().date(from: (task?.taskDate)!)!
        datepicker.date     = date
            
        } else {
            dueDateSwitch.isOn  = false
            datepicker.isHidden = true
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupUI() {
        taskTitleTF.layer.cornerRadius = 10
        noteTV.layer.cornerRadius      = 13
        doneButton.layer.cornerRadius  = 13
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        if taskTitleTF.text == "" {
            print("can't leave task title empty")
            self.showAlert(title: "Missing Task Title", message: "Please insert a task title")
        }
        
        if task?.comment == noteTV.text {
            print("task notes has not changed")
        }
        
        var note = ""
        if noteTV.text == "" {
            note = ""
        } else {
            note = noteTV.text
        }
        print("save button date \(selectedDate)")
        TaskAPI.updateTask(taskID:    (task?.taskID)!,
                           taskTitle: taskTitleTF.text!,
                           taskDate:  selectedDate,
                           comment:   note) { (success) in
            if success {
                print("Saved")
                self.homeInstance.listTasks()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dueDateSwitcher(_ sender: UISwitch) {
        if sender.isOn {
            datepicker.isHidden = false
            selectedDate        = self.formatter().string(from: datepicker.date)
            print(selectedDate)
        } else {
            datepicker.isHidden = true
            print("no date")
            selectedDate        = ""
            print("off switch: \(selectedDate)")
        }
    }
}

