//
//  NewShiftViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 15/02/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseFirestoreSwift

class NewShiftViewController : UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var shiftLengthTextField: UITextField!
    @IBOutlet weak var wageTextField: UITextField!
    
    @IBOutlet weak var waitingTimeTextField: UITextField!
    @IBOutlet weak var fiftySwitch: UISwitch!
    @IBOutlet weak var traineeSwitch: UISwitch!
    @IBOutlet weak var lunchSwitch: UISwitch!
    
    let realm = try! Realm()
    
    let db = Firestore.firestore()
    
    let datePicker = UIDatePicker()
    var selectedDate : Date?
    var usersRestaurant : String?
    
    @IBAction func addShiftPressed(_ sender: UIButton) {
        
        guard let loggedUserInfo = Auth.auth().currentUser else {
            fatalError("could")
            }
        
        let userRef = db.collection("users").document(loggedUserInfo.uid)
//        let monthQuery = restaurantRef.
        let shiftRef = userRef.collection("shifts")

        let newShift = Shift()
        
        let doubleWage = convertToDouble(wageTextField.text)
        let doubleLength = convertToDouble(shiftLengthTextField.text)
        let doubleWaitingTime = convertToDouble(waitingTimeTextField.text)
        
        shiftRef.addDocument(data: [
            "date" : selectedDate!,
            "wage" : doubleWage,
            "length" : doubleLength,
            
            "fifty" : fiftySwitch.isOn,
            "training" : traineeSwitch.isOn,
            "noon" : lunchSwitch.isOn,
            "waiting" : doubleWaitingTime,
            "total" : calcTotal(wage: doubleWage, length: doubleLength)
            
            
        ]) { (error) in
            if let e = error {
                print(e.localizedDescription)
            }
        }
        
        
        
        
        do {
            try realm.write {
                newShift.date = selectedDate
                newShift.length = doubleLength
                newShift.wage = doubleWage
                
                newShift.waiting = doubleWaitingTime
                newShift.fifty = fiftySwitch.isOn
                newShift.noon = lunchSwitch.isOn
                newShift.training = traineeSwitch.isOn
                newShift.total = calcTotal(wage: doubleWage, length: doubleLength)
                realm.add(newShift)
            }
        } catch {
            print("Error saving realm data \(error)")
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateTextField.delegate = self
        changeTextFieldUI()
        fetchUserData()
    }
    
    
    
    //MARK: - Data Fetching Methods
    
    func fetchUserData() {
           
           guard let loggedUser = Auth.auth().currentUser else {
               fatalError("Couldn't fetch logged in user")}
           
           let usersRef = db.collection("users")
           let query = usersRef.whereField("uid", isEqualTo: loggedUser.uid)
            var userDataField : String?
           
           query.getDocuments { (querySnapshot, error) in
               if let error = error {
                   print(error.localizedDescription)
               } else {
                   if let snapshotDocument = querySnapshot?.documents {
                       for document in snapshotDocument {
                           let user = document.data()
                            userDataField = user["restaurant"] as? String
                            self.usersRestaurant = userDataField

                       }
                   }
               }
           }
       }
    
    
    
    
    //MARK: - Convertion functions
    
    //Convert String to Double for Realm
    private func convertToDouble(_ text: String?) -> Double {
        if let safeValue = text {
            if let doubleValue = Double(safeValue) {
                return doubleValue
            } else {
                fatalError("can't unwrap optional Double")
            }
        } else {
            fatalError("text was nil")
        }
    }
    
    //Convert Date to String for TextField UI
    private func dateToString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Utilities.hebLocale
        dateFormatter.dateFormat = format
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
    

    //MARK: - Calc Total Method
    private func calcTotal (wage: Double, length: Double) -> Double {
        var total = 0.0
        let provision = Utilities.socialProvision
        
        if fiftySwitch.isOn && lunchSwitch.isOn {
            total = (wage * length) - (provision - 20.0)
        } else if fiftySwitch.isOn {
            total = (wage * length) - provision
        } else if fiftySwitch.isOn == false {
            total = wage * length
        }
        return total
    }
}

//MARK: - UITextField Delegate Methods
extension NewShiftViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createPickerView()
        changeTextFieldUI()
        dismissPickerView()
    }
}


//MARK: - Creating PickerView Dropdown
extension NewShiftViewController  {
    func createPickerView() {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        dateTextField.inputView = datePicker
    }
    func changeTextFieldUI() {
        datePicker.addTarget(nil, action: #selector(NewShiftViewController.textFieldDidBeginEditing(_:)), for: .valueChanged)
        let dateDescription = dateToString(datePicker.date, format: "EEEE")
        let dateNumbers = dateToString(datePicker.date, format: "dd/MM")
        self.dateTextField.text = "\(dateDescription) \(dateNumbers)"
        selectedDate = datePicker.date
    }
    
    func dismissPickerView() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        dateTextField.inputAccessoryView = toolBar
        
    }
    @objc func action() {
        view.endEditing(true)
    }
    
    
    
}

//MARK: - Date extension

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}

