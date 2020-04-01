//
//  Constants.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 21/01/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import Foundation

struct K {
    static let welcomeLogin = "goToLogin"
    static let welcomeRegister = "goToRegister"
    static let registerSegue = "registerToMain"
    static let loginSegue = "loginToMain"
    static let firstLoginSegue = "loginToFirst"
    static let showNewShiftParentSegue = "goToParentNewShift"
    static let showPopupSegue = "showPopup"
    static let backToMain = "backToMain"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
    struct FSnames {
           static let date = "date"
           static let fifty = "fifty"
           static let length = "length"
           static let noon = "noon"
           static let totalTax = "total_for_tax"
           static let trainee = "training"
           static let wage = "wage"
           static let waiting = "waiting"
       }
       
}
