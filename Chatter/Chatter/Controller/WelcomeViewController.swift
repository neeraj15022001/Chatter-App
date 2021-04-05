//
//  ViewController.swift
//  Chatter
//
//  Created by Neeraj Gupta on 10/10/20.
//  Copyright © 2020 Neeraj Gupta. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var appDescriptionLabel: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = #colorLiteral(red: 0.2632110481, green: 0, blue: 0.8705882353, alpha: 1).cgColor
        loginButton.layer.cornerRadius = loginButton.frame.height / 2.0
        signupButton.layer.cornerRadius = signupButton.frame.height / 2.0
        appDescriptionLabel.text = ""
        let appDescription : String = "World's Most Private Chatting App"
        var counter = 0.0
        for letter in appDescription {
            Timer.scheduledTimer(withTimeInterval: 0.1 * counter, repeats: false) { (timer) in
                self.appDescriptionLabel.text?.append(letter)
            }
            counter += 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

