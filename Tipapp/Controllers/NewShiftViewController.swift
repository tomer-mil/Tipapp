//
//  NewShiftViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 15/02/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class NewShiftViewController : UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var shiftLengthTextField: UITextField!
    @IBOutlet weak var wageTextField: UITextField!
    
    @IBOutlet weak var waitingTimeTextField: UITextField!
    @IBOutlet weak var fiftySwitch: UISwitch!
    @IBOutlet weak var traineeSwitch: UISwitch!
    @IBOutlet weak var lunchSwitch: UISwitch!
    
    let realm = try! Realm()
    let datePicker = UIDatePicker()
    let hebLocale = Locale(identifier: "he_IL")
    var selectedDate : Date?
    
    
    @IBAction func addShiftPressed(_ sender: UIButton) {
        let newShift = Shift()
        
        let doubleWage = convertToDouble(wageTextField.text)
        let doubleLength = convertToDouble(shiftLengthTextField.text)
        let doubleWaitingTime = convertToDouble(waitingTimeTextField.text)
        
        do {
            try realm.write {
                newShift.dateCreated = selectedDate
                newShift.length = doubleLength
                newShift.wage = doubleWage
                
                newShift.waiting = doubleWaitingTime
                newShift.fifty = fiftySwitch.isOn
                newShift.noon = lunchSwitch.isOn
                newShift.training = traineeSwitch.isOn
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
    }
    
    
    
    
    
    
    
    
    //MARK: - Convertion functions
    
    //Convert String to Double for Realm
    func convertToDouble(_ text: String?) -> Double {
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
    func dateToString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = hebLocale
        dateFormatter.dateFormat = format
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
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
