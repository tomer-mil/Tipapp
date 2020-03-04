//
//  MainViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 21/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import RealmSwift

class MainViewController: UIViewController {
    
    var shifts : Results<Shift>?
    
    let realm = try! Realm()
    
    var userName = ""
    let date = Date()
    
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var totalShiftsLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    
    @IBOutlet weak var averageDailyMoney: UILabel!
    @IBOutlet weak var averageHourly: UILabel!
    @IBOutlet weak var averageTime: UILabel!
    
    @IBOutlet weak var kupa: UILabel!
    
    @IBAction func addNewShiftPressed(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("MainVC will disappear")
    }
    
    
    
    
    
    
    //MARK: - UI Methods
    private func updateUI() {
        print("passed name to main: \(userName)")
        helloLabel.text! = "שלום \(userName)"
        updateTotalsUI()
        updateAveragesUI()
        
    }
    private func updateTotalsUI() {
        shifts = realm.objects(Shift.self)
        // total money
        if let totalMoneyDouble : Double = shifts?.sum(ofProperty: "total") {
            let flooredTotal = Int(floor(totalMoneyDouble))
            totalMoneyLabel.text = "\(flooredTotal)₪"
        } else {
            print("Shifts Results is nil")
        }
        //total shifts
        if let totalShifts = shifts?.count {
            totalShiftsLabel.text = "משמרות: \(totalShifts)"
        } else {
            print("Shifts Results is nil")
        }
        // total hours
        if let totalHours : Double = shifts?.sum(ofProperty: "length") {
            totalHoursLabel.text = "שעות: \(totalHours)"
        }
    }
    
    private func updateAveragesUI() {
        
    }
}

