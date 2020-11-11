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
    @IBOutlet weak var datePickerStackView: UIStackView!
    
    
    var selectedDate = ""
    var task: UserTask?
    var delegate: updateTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribeToKeyboardNotification()
        taskTitleTF.text = task?.taskName
        noteTV.text      = task?.comment
        
        if task?.taskDate != nil {
            dueDateSwitch.isOn  = true
            datePickerStackView.isHidden = false
            let date = self.formatter().date(from: (task?.taskDate)!)!
            datepicker.date     = date
            
        } else {
            dueDateSwitch.isOn  = false
            datePickerStackView.isHidden = true
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
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
        
        if task?.comment == noteTV.text {
            print("task notes has not changed")
        }
        
        var note = ""
        if noteTV.text == "" {
            note = ""
        } else {
            note = noteTV.text
        }
        
        if taskTitleTF.text == "" {
            print("can't leave task title empty")
            self.showAlert(title: "Missing Task Title", message: "Please insert a task title")
        } else {
            
            print("save button date \(selectedDate)")
            TaskAPI.updateTask(taskID:    (task?.taskID)!,
                               taskTitle: taskTitleTF.text!,
                               taskDate:  selectedDate,
                               comment:   note) { (success) in
                if success {
                    self.delegate?.handleUpdate()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func dueDateSwitcher(_ sender: UISwitch) {
        if sender.isOn {
            datePickerStackView.isHidden = false
            selectedDate        = self.formatter().string(from: datepicker.date)
            print(selectedDate)
        } else {
            datePickerStackView.isHidden = true
            selectedDate        = ""
            print("off switch: \(selectedDate)")
        }
    }
    
    // MARK: - Keyboard Functions
    
    func subscribeToKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if noteTV.isFirstResponder {
            let textFieldPosition = noteTV.frame.origin.y + noteTV.frame.size.height
            if textFieldPosition > (view.frame.size.height - getKeyboardHeight(notification)){
                
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= getKeyboardHeight(notification)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notifcation: Notification) {
        if noteTV.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardFrame.cgRectValue.height
        
    }
}

