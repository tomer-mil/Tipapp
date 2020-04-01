//
//  RealmBrain.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 09/03/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
import FirebaseFirestoreSwift

struct RealmBrain {
    
    let fireBrain = FirebaseBrain()
    let realm : Realm
    var currentMonthShifts : Results<Shift>
    var allShifts : Results<Shift>
    
    var totalShifts : Int {
        get {
            return currentMonthShifts.count
        }
    }
    var totalPreTax : Double {
        return currentMonthShifts.sum(ofProperty: "total")
    }
    var totalAfterTax : Double {
        get {
            let taxBrain = TaxBrain()
            let tax = taxBrain.calcTax(amount: totalPreTax)
            return totalPreTax - tax
        }
    }
    var totalHours : Double {
        return currentMonthShifts.sum(ofProperty: "length")
    }
    
    var averagePerShift : Double {
        get {
            let average = currentMonthShifts.average(ofProperty: "total") as Double? ?? 0.0
            return average
        }
    }
    var averagePerHour : Double {
        get {
            let average = currentMonthShifts.average(ofProperty: "wage") as Double? ?? 0.0
            return average
        }
    }
    var averageLength : Double {
        get {
            let average = currentMonthShifts.average(ofProperty: "length") as Double? ?? 0.0
            return average
        }
    }
    
    init() {
        
    // Setting the Realm Configuration
        if let loggedUser = fireBrain.loggedUser {
            let uid = loggedUser.uid
            var config = Realm.Configuration()
            
            config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(uid).realm")
            Realm.Configuration.defaultConfiguration = config
            
            realm = try! Realm(configuration: config)
            print("Realm config set successfull!")
            
        } else {
            print("no logged user for realm config")
            realm = try! Realm()
        }
    // Filterring Current Month Shifts
        let currentDate = Date()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let stringMonth = monthFormatter.string(from: currentDate)
        var nextMonth : Date {
            get {
                var nextComponents = DateComponents()
                nextComponents.setValue(1, for: .day)
                nextComponents.setValue(2020, for: .year)
                nextComponents.setValue((Int(stringMonth)! + 1), for: .month)
                nextComponents.setValue(0, for: .hour)
                let month = Calendar.current.date(from: nextComponents) ?? Date(timeIntervalSince1970: 0)
                return month
            }
        }
        var prevMonth : Date {
            get {
                var prevComponents = DateComponents()
                prevComponents.setValue(1, for: .day)
                prevComponents.setValue(2020, for: .year)
                prevComponents.setValue((Int(stringMonth)! - 1), for: .month)
                prevComponents.setValue(0, for: .hour)
                let month = Calendar.current.date(from: prevComponents) ?? Date(timeIntervalSince1970: 0)
                return month
            }
        }
        
        let monthPredicate = NSCompoundPredicate(format: "date BETWEEN %@", [prevMonth, nextMonth])
        currentMonthShifts =  realm.objects(Shift.self).filter(monthPredicate).sorted(byKeyPath: "date", ascending: true)
        allShifts = realm.objects(Shift.self).filter("FALSEPREDICATE")
    }
    
    
    
    //MARK: - Set Realm directory for user
    func setDefaultRealmForUser() {
        guard let loggedUser = fireBrain.loggedUser else {
            fatalError("no logged user found")
        }
        let uid = loggedUser.uid
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(uid).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    //MARK: - Create All shifts
    
    func createRealmShifts() {
        fireBrain.fetchAllShifts { (monthDocuments) in
            for document in monthDocuments {
                let shift = document.data()
                let newShift = Shift()
                
                let timestampDate = shift[K.FSnames.date] as? Timestamp
                let dateField = timestampDate?.dateValue()
                
                newShift.id = document.documentID
                
                newShift.date = dateField
                newShift.fifty = shift[K.FSnames.fifty] as! Bool
                newShift.length = shift[K.FSnames.length] as! Double
                newShift.noon = shift[K.FSnames.noon] as! Bool
                newShift.total = shift[K.FSnames.totalTax] as! Double
                newShift.training = shift[K.FSnames.trainee] as! Bool
                newShift.wage = shift[K.FSnames.wage] as! Double
                newShift.waiting = shift[K.FSnames.waiting] as! Double
                
                do {
                    try self.realm.write {
                        self.realm.add(newShift, update: .modified)
                    }
                } catch {
                    print("Error saving realm data \(error)")
                }
            }
        }
    }
    //MARK: - Filter Months Shifts
    
    func filterThisMonthShifts() {
        let currentDate = Date()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let stringMonth = monthFormatter.string(from: currentDate)
        var nextMonth : Date {
            get {
                var nextComponents = DateComponents()
                nextComponents.setValue(1, for: .day)
                nextComponents.setValue(2020, for: .year)
                nextComponents.setValue((Int(stringMonth)! + 1), for: .month)
                nextComponents.setValue(0, for: .hour)
                let month = Calendar.current.date(from: nextComponents) ?? Date(timeIntervalSince1970: 0)
                return month
            }
        }
        var prevMonth : Date {
            get {
                var prevComponents = DateComponents()
                prevComponents.setValue(1, for: .day)
                prevComponents.setValue(2020, for: .year)
                prevComponents.setValue((Int(stringMonth)! - 1), for: .month)
                prevComponents.setValue(0, for: .hour)
                let month = Calendar.current.date(from: prevComponents) ?? Date(timeIntervalSince1970: 0)
                return month
            }
        }
        
        let monthPredicate = NSCompoundPredicate(format: "date BETWEEN %@", [prevMonth, nextMonth])
        
        let monthShifts = realm.objects(Shift.self).filter(monthPredicate).sorted(byKeyPath: "date", ascending: true)
        
        print("current month Shifts: ", monthShifts,
              "next month is: ", nextMonth,
              "prev month is: ", prevMonth
        )
    }
}



