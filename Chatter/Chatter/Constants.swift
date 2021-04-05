//
//  Constants.swift
//  Chatter
//
//  Created by Neeraj Gupta on 14/10/20.
//  Copyright © 2020 Neeraj Gupta. All rights reserved.
//

import Foundation

struct Constants {
    static let nibName = "MessageCell"
    static let reusableCell = "Cells"
    static let signUpSuccesfulSegue = "signupToChat"
    static let loginSuccessfulSegue = "loginToChat"
    
    struct FStore {
        static let collectionName  = "message"
        static let bodyField = "body"
        static let senderField = "sender"
        static let dateField = "date"
        static let userCollectionName = "NewUsers"
    }
}
