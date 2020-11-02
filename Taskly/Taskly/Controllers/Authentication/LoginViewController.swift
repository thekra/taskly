//
//  LoginViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 15/03/1442 AH.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.clipsToBounds = true
        emailTF.layer.mask?.borderColor = UIColor.black.cgColor
        emailTF.layer.borderWidth = 0.8
        emailTF.layer.cornerRadius = 13
        
        passwordTF.clipsToBounds = true
        passwordTF.layer.mask?.borderColor = UIColor.black.cgColor
        passwordTF.layer.borderWidth = 0.8
        passwordTF.layer.cornerRadius = 13
        
        loginButton.layer.cornerRadius = 13
    }
}
