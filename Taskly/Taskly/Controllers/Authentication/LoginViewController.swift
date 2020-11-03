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
        setupUI()
    }
    
    func setupUI() {
        emailTF.setupTextField(emailTF, borderWidth: 0.8, cornerRadius: 13)
        passwordTF.setupTextField(passwordTF, borderWidth: 0.8, cornerRadius: 13)
        loginButton.layer.cornerRadius = 13
    }
    
    @IBAction func Login(_ sender: UIButton) {
//        Loginn.login { (Loginn) in
//            print(Loginn)
//        }
        //(email: emailTF.text!, password: passwordTF.text!)
        AthuenticationAPI.login(email: "nils.rath@example.net", password: "password") { (LoginResponse, success) in
            if success {
                print("logged in")
                print("TOKEN: \(LoginResponse.accessToken)")
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "home")
                    mainTabBarController.modalPresentationStyle = .fullScreen
                    self.present(mainTabBarController, animated: true, completion: nil)
                }
            }
        }
    }
}
