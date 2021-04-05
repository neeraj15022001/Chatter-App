//
//  LoginViewController.swift
//  Chatter
//
//  Created by Neeraj Gupta on 11/10/20.
//  Copyright © 2020 Neeraj Gupta. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = #colorLiteral(red: 0.2632110481, green: 0, blue: 0.8705882353, alpha: 1).cgColor
        loginButton.layer.cornerRadius = loginButton.frame.height / 2.0
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text,let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        let errorString : String
                        switch errCode {
                        case .wrongPassword:
                            errorString = "Password is Wrong"
                        case .unverifiedEmail :
                            errorString = "Email is unverified"
                        case .invalidEmail :
                            errorString = "Email is Invalid"
                        case .missingEmail :
                            errorString = "Please Provide Email"
                        default:
                            errorString = "Unknown Error"
                        }
                        let alert = UIAlertController(title: "Error While Logging In", message: errorString, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                    
                } else {
                    print("Authentication Successfull")
                    self.performSegue(withIdentifier: Constants.loginSuccessfulSegue, sender: self)
                }
            }
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
