//
//  LoginViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 21/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class LoginViewController: UIViewController {
    
    private let db = Firestore.firestore()
    var userName : String?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                
                if let e = error {
                    let popup = UIAlertController(title: "Error with Login", message: e.localizedDescription, preferredStyle: .alert)
                    popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in popup.dismiss(animated: true, completion: nil )} ))
                    self.present(popup, animated: true, completion: nil)
                    print(e)
                } else {
                    self.fetchUserName()
                }
            }
        }
    }
    
    
//MARK: - Passing the user's first name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.loginSegue {
            let destinationVC = segue.destination as! MainViewController
            destinationVC.userName = userName!
        }
    }
    
    func fetchUserName(){
        
        guard let loggedUser = Auth.auth().currentUser else {
            fatalError("Couldn't fetch logged in user")}
        
        let usersRef = db.collection("users")
        let query = usersRef.whereField("uid", isEqualTo: loggedUser.uid)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for document in snapshotDocument {
                        let user = document.data()
                        let fetchedUserName = user["name"] as? String
                        
                        self.userName = fetchedUserName
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: K.loginSegue, sender: self)
                        }
                    }
                }
            }
        }
    }
}
