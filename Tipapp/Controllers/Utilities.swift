//
//  Utilities.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 16/02/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

struct Utilities {
    // Constants
    
    static let hebLocale = Locale(identifier: "he_IL")
    static let socialProvision = 50.0
    static let minimumWage = 29.12
    
    
   
    // Creating an Error Popoup
    static func createErrorPopup(with title: String, with messeage: String) {
        let alert = UIAlertController(title: title, message: messeage, preferredStyle: .alert)
        let action = UIAlertAction(title: "סגור", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
    }
    
    //Firebase Shit
    
    let db = Firestore.firestore()
    
    
}


