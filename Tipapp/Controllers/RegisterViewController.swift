//
//  RegisterViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 21/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import RealmSwift

class RegisterViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var secondPasswordTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var restaurantPickerView: UIPickerView!
    @IBAction func signupButtonPressed(_ sender: Any) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email , password: password) { authResult, error in
                if let e = error {
                    let popup = UIAlertController(title: "Error with registration", message: e.localizedDescription, preferredStyle: .alert)
                    popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in popup.dismiss(animated: true, completion: nil )} ))
                    self.present(popup, animated: true, completion: nil)
                    print(e.localizedDescription)
                } else {
                    // navigate to chat view controller
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
        addUserInfo(name: usernameTextfield.text, restaurant: "abie")
    }
    func addUserInfo(name: String?, restaurant: String?) {
        if let user = Auth.auth().currentUser {
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "user_id" : user.uid ,
                "name" : name ?? "ללא שם" ,
                "restaurant" : restaurant ?? "לא הוזנה מסעדה"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
}
    
    
    
    
    
    //MARK: - Textfield Delegate Methods
    
//extension RegisterViewController: UITextFieldDelegate {
//        func textFieldDidEndEditing(_ textField: UITextField) {
//            resignFirstResponder()
//        }
//}

//MARK: - New User Functions




