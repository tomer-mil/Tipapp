//
//  ShiftModel.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 21/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import Foundation
import RealmSwift

class Shift: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var date : Date?
    @objc dynamic var noon : Bool = false
    @objc dynamic var wage : Double = 0.0
    @objc dynamic var length : Double = 0.0
    @objc dynamic var waiting : Double = 0.0
    @objc dynamic var fifty : Bool = true
    @objc dynamic var training : Bool = false
    @objc dynamic var total : Double = 0.0

    override static func primaryKey() -> String? {
        return "id"
    }
}
