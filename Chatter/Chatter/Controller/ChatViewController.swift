//
//  ChatViewController.swift
//  Chatter
//
//  Created by Neeraj Gupta on 11/10/20.
//  Copyright © 2020 Neeraj Gupta. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatViewController:UIViewController {
    
    var messages : [Message] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: Constants.nibName , bundle: nil), forCellReuseIdentifier: Constants.reusableCell)
        loadMessage()
    }
    
    // MARK:- Fetch Realtime Messages
    func loadMessage() {
        Firestore.firestore().collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                if let snapShot = querySnapshot?.documents {
                    for doc in snapShot {
                        let dataFetched = doc.data()
                        if let message = dataFetched[Constants.FStore.bodyField] as? String, let sender = dataFetched[Constants.FStore.senderField] as? String {
                            let newMessage = Message(sender: sender, messageBody: message)
                            print(newMessage)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        
                        
                    }
                }
            }
        }
        
    }
    // MARK:- Send Message Action
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if let currentUserEmail = Auth.auth().currentUser!.email,let messageToBeSaved = messageTextField.text {
            var ref: DocumentReference? = nil
            ref = Firestore.firestore().collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField : currentUserEmail,
                Constants.FStore.bodyField: messageToBeSaved,
                Constants.FStore.dateField : Date().timeIntervalSince1970
            ]) { error in
                if let err = error {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            DispatchQueue.main.async {
                self.messageTextField.text = ""
            }
        }
        
    }
    // MARK:- Logout Button
    @IBAction func LogoutButtonPRessed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    

}


// MARK:- UITableviewDelegates
extension ChatViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCell , for: indexPath) as! MessageCell
        cell.label?.text = messages[indexPath.row].messageBody
        let message = messages[indexPath.row]
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImage.isHidden = true
            cell.rightImage.isHidden = false
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.2632110481, green: 0, blue: 0.8705882353, alpha: 1)
            cell.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            cell.leftImage.isHidden = false
            cell.rightImage.isHidden = true
//            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.9722703223, green: 0.9792027417, blue: 1, alpha: 1)
//            cell.label.textColor = #colorLiteral(red: 0.2632110481, green: 0, blue: 0.8705882353, alpha: 1)
        }
        return cell
    }
}



