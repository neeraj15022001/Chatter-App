//
//  SignupViewController.swift
//  Chatter
//
//  Created by Neeraj Gupta on 11/10/20.
//  Copyright © 2020 Neeraj Gupta. All rights reserved.
//

import UIKit
import Firebase


class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = signupButton.frame.height / 2.0
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text,let password = passwordTextField.text, let userName = usernameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        let errorString : String
                        switch errCode {
                        case .invalidEmail :
                            errorString = "Email is invalid"
                        case .missingEmail :
                            errorString = "Please Provide Email"
                        case .emailAlreadyInUse:
                            errorString = "Email In Use"
                        case .weakPassword:
                            errorString = "Password Should be Greater or Equal to 6"
                        default:
                            errorString = "Unknown Error"
                        }
                        let alert = UIAlertController(title: "Error While Logging In", message: errorString, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    var ref: DocumentReference? = nil
                    ref = Firestore.firestore().collection(Constants.FStore.userCollectionName).addDocument(data: [
                        "name": userName,
                        "email": email,
                        "uid": String(Auth.auth().currentUser!.uid)
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                    print("Account Created Successfully")
                    self.performSegue(withIdentifier: Constants.signUpSuccesfulSegue, sender: self)
                }
            }
        }
    }
}

// MARK:- Disable icloud Keychain
extension UITextField {
    func disableAutoFill() {
        if #available(iOS 13, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}
