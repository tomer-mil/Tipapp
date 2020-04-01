//
//  MainViewController.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 21/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseFirestoreSwift

class MainViewController: UIViewController, NewShiftAddedProtocol {
    
    func newShiftAdded() {
    
    }
    
    
    private let db = Firestore.firestore()
    private let realm = try! Realm()
    
    let loggedUser = Auth.auth().currentUser
    
    var userName = ""
    var uid : String?
    
    let taxBrain = TaxBrain()
    let fireBrain = FirebaseBrain()
    var realmBrain = RealmBrain()
    
    var newShiftVC = NewShiftViewController()
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var totalShiftsLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    
    @IBOutlet weak var averagePerShift: UILabel!
    @IBOutlet weak var averagePerHour: UILabel!
    @IBOutlet weak var averageLength: UILabel!
    
    @IBOutlet weak var kupa: UILabel!
    
    @IBAction func addNewShiftPressed(_ sender: Any) {
        addChildVC()
    }
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newShiftVC.delegate = self

        self.realmBrain.filterThisMonthShifts()
        DispatchQueue.main.async {
            self.updateUI()
        }
        print("Realm file configuration: ", realm.configuration.fileURL!)
    }
    
    //MARK: - UI Methods
    func updateUI() {
        // Name
        print("passed name to main: \(userName)")
        helloLabel.text! = "שלום \(userName)"
        
        // Totals
        self.totalMoneyLabel.text = "\(Int(floor(realmBrain.totalAfterTax)))₪"
        self.totalShiftsLabel.text = "משמרות:" + " " + "\(realmBrain.totalShifts)"
        self.totalHoursLabel.text = "שעות:" + " " + String(format: "%.1f", realmBrain.totalHours)
        
        //Average
        self.averageLength.text = String(format: "%.1f",realmBrain.averageLength) + " שעות"
        self.averagePerHour.text = String(format: "%.1f",realmBrain.averagePerHour) + "₪"
        self.averagePerShift.text = String(format: "%.1f",realmBrain.averagePerShift) + "₪"
        
        //Other
        let shiftsWithFifty = realmBrain.currentMonthShifts.filter("fifty == %@", true).count
        let kupaDifference = taxBrain.calcDifference(numberOfShifts: shiftsWithFifty, salary: realmBrain.totalPreTax)
        self.kupa.text = String(format: "%.1f",kupaDifference)
}
    
    
    
    private func updateTotalsUIWithFirebase() {
        
        var totalMonthMoney : Double = 0.0
        var totalMonthHours : Double = 0.0
        var totalMonthShifts : Int = 0
        
        fireBrain.fetchMonthShifts { (monthDocuments) in
            totalMonthShifts = monthDocuments.count
            
            for document in monthDocuments {
                let shift = document.data()
                let totalMoney = shift["total_for_tax"] as? Double
                totalMonthMoney += totalMoney ?? 0.0
                
                let totalHours = shift["length"] as? Double
                totalMonthHours += totalHours ?? 0.0
            }
            
            let taxAmount = self.taxBrain.calcTax(amount: totalMonthMoney)
            self.totalMoneyLabel.text = "\(Int(floor(totalMonthMoney - taxAmount)))₪"
            self.totalShiftsLabel.text = "משמרות:" + " " + "\(totalMonthShifts)"
            self.totalHoursLabel.text = "שעות:" + " " + String(format: "%.1f", totalMonthHours)
        }
    }

//MARK: - Add Child VC

    func addChildVC() {
        
        var _: NewShiftViewController = {
            // Load Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

            // Instantiate View Controller
            let viewController = storyboard.instantiateViewController(withIdentifier: "NewShiftStoryboard") as! NewShiftViewController
    
                viewController.delegate = self
            
            // Add View Controller as Child View Controller
            self.add(asChildViewController: viewController)

            return viewController
        }()
    }

    private func setChildVCConstraints(withChild childVC: UIViewController) {
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        childVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        childVC.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0.0).isActive = true
        childVC.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0.0).isActive = true
        
        childVC.view.heightAnchor.constraint(equalToConstant: 403).isActive = true
    }
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        setChildVCConstraints(withChild: viewController)
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
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

//extension MainViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.showNewShiftSegue {
//            let popupVC = segue.destination as! NewShiftViewController
//            popupVC.delegate = self
//        }
//    }
//}

//MARK: - NewShift Protocol
protocol NewShiftAddedProtocol {
    func newShiftAdded()
}
