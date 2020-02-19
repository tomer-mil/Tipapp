//
//  RegisterViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 21/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class RegisterViewController: UIViewController {
    
    let db = Firestore.firestore()
    private var pickerData = ["האחים", "dok דוק", "abie אייבי"]
    private var selectedRestaurant = ""
    var userName : String?
    
    @IBOutlet weak var secondPasswordTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var restaurantPickerView: UIPickerView!
    @IBOutlet weak var selectARestaurant: UITextField!
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if  let email = emailTextfield.text,
            let password = passwordTextfield.text,
            let name = usernameTextfield.text {
            Auth.auth().createUser(withEmail: email , password: password) { Result, error in
                if let e = error {
                    let popup = UIAlertController(title: "Error with registration", message: e.localizedDescription, preferredStyle: .alert)
                    popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in popup.dismiss(animated: true, completion: nil )} ))
                    self.present(popup, animated: true, completion: nil)
                    print(e.localizedDescription)
                    
                } else {
                    self.db.collection("users").document(Result!.user.uid).setData([
                        "name" : name,
                        "restaurant" : self.selectedRestaurant,
                        "uid" : Result!.user.uid
                    ]) { (error) in
                        if let e = error {
                            print(e.localizedDescription)
                        }
                    }
                    self.fetchUserName()
                    
                }
            }
        }
    }
    
    //MARK: - Fetching the user's first name methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.registerSegue {
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
                            self.performSegue(withIdentifier: K.registerSegue, sender: self)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectARestaurant.delegate = self
        
    }
    
    
}





//MARK: - PickerView Delegate Methods

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRestaurant = pickerData[row]
        selectARestaurant.text = selectedRestaurant
        pickerView.reloadAllComponents()
        print(selectedRestaurant)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        if pickerView.selectedRow(inComponent: component) == row {
            
            pickerLabel.attributedText =  NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.font:UIFont(name: "Rubik", size: 26.0)!, NSAttributedString.Key.foregroundColor: UIColor(named: "SecondaryDark")!])
        } else {
            pickerLabel.attributedText = NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.font:UIFont(name: "Rubik", size: 26.0)!, NSAttributedString.Key.foregroundColor: UIColor(named: "TextColorLight")!])
        }
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}


//MARK: - UITextField Delegate Methods
extension RegisterViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createPickerView()
        dismissPickerView()
    }
}



//MARK: - Creating UIPickerView DropDown

extension RegisterViewController {
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        selectARestaurant.inputView = pickerView
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        selectARestaurant.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
    
}





