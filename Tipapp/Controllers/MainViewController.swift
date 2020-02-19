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
import PopupKit
import EzPopup

class MainViewController: UIViewController {
    var userName = ""
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var totalShifts: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    
    @IBOutlet weak var averageDailyMoney: UILabel!
    @IBOutlet weak var averageHourly: UILabel!
    @IBOutlet weak var averageTime: UILabel!
    
    @IBOutlet weak var kupa: UILabel!
    
    @IBAction func addNewShiftPressed(_ sender: Any) {
        
//        guard let newShiftVC = newShiftVC else { return }
//        
//        let popupVC = PopupViewController(contentController: newShiftVC, popupWidth: 374, popupHeight: 420)
//        popupVC.cornerRadius = 10
//        present(popupVC, animated: true, completion: nil)
//        

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("passed name to main: \(userName)")
        helloLabel.text! = "שלום \(userName)"
    }
    
    
}
