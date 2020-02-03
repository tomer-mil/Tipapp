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
                    
                    guard let firstLogin = authResult?.additionalUserInfo?.isNewUser else { fatalError("isNewUser is nil")}
                    print(firstLogin)
                    if firstLogin == true {
                        self.performSegue(withIdentifier: K.firstLoginSegue, sender: self)
                    } else {
                        self.performSegue(withIdentifier: K.loginSegue, sender: self)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.loginSegue {
            let destinationVC = segue.destination as! LoginViewController
        } else if segue.identifier == K.firstLoginSegue {
            let destinationVC = segue.destination as! FirstLoginViewController
        }
    }
    
}
