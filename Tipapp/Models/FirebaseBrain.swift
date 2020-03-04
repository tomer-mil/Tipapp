//
//  FirebaseBrain.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 27/02/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

struct FirebaseBrain {
    
    let db = Firestore.firestore()
    
    func fetchUserData(field : String) -> String {
        
        guard let loggedUser = Auth.auth().currentUser else {
            fatalError("Couldn't fetch logged in user")}
        
        let usersRef = db.collection("users")
        let query = usersRef.whereField("uid", isEqualTo: loggedUser.uid)
        var userDataField = ""
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for document in snapshotDocument {
                        let user = document.data()
                        userDataField = user[field] as! String
                    }
                }
            }
        }
    return userDataField
    }
}
