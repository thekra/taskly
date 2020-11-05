//
//  TaskViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import UserNotifications
import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTitleTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var datePickerStackView: UIStackView!
    
    var selectedDate = ""
    var delegate: updateTable?
    let notifications = Notifications()
    var homeInstance : HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("datePicker: \(datePicker.date)")
        selectedDate = self.formatter().string(from: datePicker.date)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewDismiss))
        view.addGestureRecognizer(tap)
        topView.addGestureRecognizer(tap2)
        
    }
    
    //MARK: - dismiss keyboard function
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func viewDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        taskTitleTF.layer.cornerRadius = 10
        notesTV.layer.cornerRadius     = 13
        doneButton.layer.cornerRadius  = 13
        childView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
    }
    
    @IBAction func createTask(_ sender: UIButton) {
        
        createTask()
//        notifications.scheduleNotification()
    }
    
    func createTask() {
                
        // validation to minimum date
        
        if taskTitleTF.text == "" {
            self.showAlert(title: "Missing Task Title", message: "Please insert a task title")
        }
        
        var note = ""
        if notesTV.text == nil {
            note = ""
        } else {
            note = notesTV.text
        }
        
        TaskAPI.createTask(taskTitle: taskTitleTF.text!, taskDate: selectedDate, comment: note) { ( success )  in
            if success {
                
                self.homeInstance.listTasks()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.delegate?.listTask()
//    }
    
    @IBAction func dueDateSwitcher(_ sender: UISwitch) {
        
        if dueDateSwitch.isOn {
            datePickerStackView.isHidden = false
            let calendar        = Calendar.current
            let date            = calendar.date(byAdding: .minute, value: 2, to: datePicker.date)! // for testing
            print("date: \(date)")
            selectedDate = self.formatter().string(from: date)
        } else {
            datePickerStackView.isHidden = true
            selectedDate        = ""
        }
    }
}
