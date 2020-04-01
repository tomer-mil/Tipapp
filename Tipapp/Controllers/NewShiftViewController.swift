//
//  NewShiftViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 15/02/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
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
        
    private let db = Firestore.firestore()
    private let datePicker = UIDatePicker()
    private var selectedDate : Date?
    private var usersRestaurant : String?
    
    lazy var realmBrain = RealmBrain()
    var delegate : NewShiftAddedProtocol?
    let text = "text from new shift vc"
    
//    init(with delegate : NewShiftAddedProtocol) {
//        self.delegate = delegate
//    }
    
 //MARK: - addShiftPressed
    @IBAction func addShiftPressed(_ sender: UIButton) {
        
        guard let loggedUserInfo = Auth.auth().currentUser else {
            fatalError("could")
            }
        
        let userRef = db.collection("users").document(loggedUserInfo.uid)
        let shiftRef = userRef.collection("shifts")
        
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
            "total_for_tax" : calcTotalForTax(wage: doubleWage, length: doubleLength)
            
            
        ]) { (error) in
            if let e = error {
                print(e.localizedDescription)
            }
        }
        guard let safeDelegate = delegate else {
            fatalError("delegate is nil")
        }

            safeDelegate.newShiftAdded()
        
        DispatchQueue.main.async {
            self.remove(asChildViewController: self)
        }
        
    }

    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTextFieldUI()
        fetchUserData()
        DispatchQueue.main.async {
            self.dateTextField.delegate = self

        }
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
    
    //MARK: - Child VC Methods
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    
    
    
    //MARK: - Calc Total Method
    private func calcTotalWithProvision (wage: Double, length: Double) -> Double {
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
    
    private func calcTotalForTax(wage: Double, length: Double) -> Double {
        var total = 0.0
        total = wage * length
        
        let waitingTime = Double(self.waitingTimeTextField.text ?? "0.0") ?? 0.0
        total += (waitingTime * Utilities.minimumWage)
        
        if traineeSwitch.isOn {
            total += 50.0
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
        let dateFullDescription = "\(dateDescription) \(dateNumbers)"
        DispatchQueue.main.async {
            self.dateTextField.text = dateFullDescription
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd/MM"
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


