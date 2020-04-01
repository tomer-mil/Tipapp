//
//  File.swift
//  Tipapp
//
//  Created by Tomer Mildworth on 09/03/2020.
//  Copyright © 2020 Tomer Mildworth. All rights reserved.
//

import Foundation

struct TaxStep {
    var until : Double
    var taxRate : Double
    var maxTax : Double
    
    init(until: Double, taxRate: Double, maxTax: Double) {
        self.until = until
        self.taxRate = taxRate
        self.maxTax = maxTax
    }
}
