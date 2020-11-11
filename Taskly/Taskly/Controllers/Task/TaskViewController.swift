//
//  TaskViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import UserNotifications
import UIKit

protocol updateTable { // capital
    func handleUpdate()
}

class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskTitleTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var datePickerStackView: UIStackView!
    
    var selectedDate: String?
    var delegate: updateTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribeToKeyboardNotification()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewDismiss))
        view.addGestureRecognizer(tap)
        topView.addGestureRecognizer(tap2)
        datePicker.minimumDate = Date()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
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
    }
    
    func createTask() {
        
        var note = ""
        if notesTV.text == nil {
            note = ""
        } else {
            note = notesTV.text
        }
        
        var dueDate: Date?
        if dueDateSwitch.isOn {
            dueDate = datePicker.date
            selectedDate = formatter().string(from: dueDate!)
        } else {
            selectedDate = nil
        }
        
        if taskTitleTF.text == "" {
            self.showAlert(title: "Missing Task Title", message: "Please insert a task title")
        } else {
            TaskAPI.createTask(taskTitle: taskTitleTF.text!, taskDate: selectedDate, comment: note) { ( success )  in
                if success {
                    self.delegate?.handleUpdate()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func dueDateSwitcher(_ sender: UISwitch) {
        
        if dueDateSwitch.isOn {
            datePickerStackView.isHidden = false
            selectedDate        = self.formatter().string(from: datePicker.date)
        } else {
            datePickerStackView.isHidden = true
            selectedDate        = nil
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
        if notesTV.isFirstResponder {
            print("keyboard will show")
            let textFieldPosition = notesTV.frame.origin.y + notesTV.frame.size.height
            
            if textFieldPosition < (view.frame.size.height - getKeyboardHeight(notification)) {
                
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= getKeyboardHeight(notification)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notifcation: Notification) {
        if notesTV.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrame.cgRectValue.height
        
    }
}
