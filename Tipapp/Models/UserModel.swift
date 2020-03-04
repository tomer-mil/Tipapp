//
//  UserModel.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 22/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUser: Object {
    @objc dynamic var user_id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var restaurant : String = ""
}
