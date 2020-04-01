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

class FirebaseBrain {
    
    let db = Firestore.firestore()
    let loggedUser = Auth.auth().currentUser
    let monthShiftsArray : [String : Any] = [:]
    
    //MARK: - fetchUserData Method
    func fetchUserData(field : String, myDataType: Any.Type) -> String {
        var userDataField = ""

        if let safeUser = loggedUser {
            let usersRef = db.collection("users")
            let query = usersRef.whereField("uid", isEqualTo: safeUser.uid)
            
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
        }
    return userDataField
    }
    
    //MARK: - fetchMonthlyShifts Method
    
    func fetchMonthShifts(completion: @escaping (_ documentQuery: [QueryDocumentSnapshot]) -> Void) {
        var monthDocumentSnapshot : [QueryDocumentSnapshot] = []
        if let safeUser = loggedUser {
            let userRef = db.collection("users").document(safeUser.uid)
            let shiftRef = userRef.collection("shifts")
            
            let currentMonth = Date()
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(timeIntervalSince1970: 0)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy HH:mm:ss"
            
            let currentDateInTimestamp : Timestamp = Timestamp(date: currentMonth)
            let previousDateInTimestamp : Timestamp = Timestamp(date: previousMonth)
            shiftRef
                .whereField("date", isLessThanOrEqualTo: currentDateInTimestamp)
                .whereField("date", isGreaterThanOrEqualTo: previousDateInTimestamp)
                .getDocuments { (QuerySnapshot, error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        if let safeDocuments = QuerySnapshot?.documents {
                            monthDocumentSnapshot = safeDocuments
                        }
                    }
                    completion(monthDocumentSnapshot)
            }
        }
    }

    func convertTimestampToDate(timestamp: Timestamp) {
        
        
        
    }
    func fetchAllShifts(completion: @escaping (_ documentQuery: [QueryDocumentSnapshot]) -> Void) {
        var monthDocumentSnapshot : [QueryDocumentSnapshot] = []
        if let safeUser = loggedUser {
            let userRef = db.collection("users").document(safeUser.uid)
            let shiftRef = userRef.collection("shifts")
            
            shiftRef
                .getDocuments { (QuerySnapshot, error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        if let safeDocuments = QuerySnapshot?.documents {
                            monthDocumentSnapshot = safeDocuments
                        }
                    }
                    completion(monthDocumentSnapshot)
            }
        }
    }



}

