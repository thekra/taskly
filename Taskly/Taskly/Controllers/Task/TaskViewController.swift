//
//  TaskViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTitleTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    
    var formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("datePicker: \(datePicker.date)")
//        selectedDate.formatter(from: datePicker.date)
        selectedDate = formatter.string(from: datePicker.date)
    }
    
    func setupUI() {
        taskTitleTF.layer.cornerRadius = 10
        notesTV.layer.cornerRadius = 13
        doneButton.layer.cornerRadius = 13
    }
    
    @IBAction func createTask(_ sender: UIButton) {
        createTask()
    }
    
    func createTask() {
        
        #warning("I don't want it like this but it's temporary")
        var note = ""
        if notesTV.text == nil {
            note = ""
        } else {
            note = notesTV.text
        }
        
        TaskAPI.createTask(taskTitle: taskTitleTF.text!, taskDate: selectedDate, comment: note) { ( success )  in
            if success {
//                self.dismiss(animated: true, completion: nil)
//                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "home")
                    mainTabBarController.modalPresentationStyle = .fullScreen
                    self.present(mainTabBarController, animated: true, completion: nil)
//                }
            } else {
                print("meh")
            }
        }
    }
    
    @IBAction func dueDateSwitcher(_ sender: UISwitch) {
        
        if dueDateSwitch.isOn {
            datePicker.isHidden = false
            selectedDate = formatter.string(from: datePicker.date)
        } else {
            datePicker.isHidden = true
            selectedDate = ""
        }
    }
    
}
