
struct TaxStep {
    var until : Double
    var taxRate : Double
    var maxTax : Double
}


//12000
let firstTS = TaxStep(until: 6310, taxRate: 0.1, maxTax: 631)
let secondTS = TaxStep(until: 9050, taxRate: 0.14, maxTax: 384)
let thirdTS = TaxStep(until: 14530, taxRate: 0.2, maxTax: 1096)
let fourthTS = TaxStep(until: 20200, taxRate: 0.31, maxTax: 1758)
let fifthTS = TaxStep(until: 42030, taxRate: 0.35, maxTax: 7641)
let sixthTS = TaxStep(until: 54130, taxRate: 0.47, maxTax: 5687)

let taxSteps : [TaxStep] = [firstTS, secondTS, thirdTS, fourthTS, fifthTS, sixthTS]

func calcTax(amount: Double) -> Double {
    var totalTax = 0.0
    for (index, taxStep) in taxSteps.enumerated() {
        if amount < 6310 {
            totalTax = amount*0.1
        }
        else if amount > 54130 {
            totalTax += (17196 + (amount - 54130) * 0.5)
            break
        }
        else if amount > taxStep.until {
            totalTax += taxStep.maxTax
        } else {
            totalTax += Double(amount - taxSteps[index - 1].until) * taxStep.taxRate
            break
        }
    }
    return totalTax
}

calcTax(amount: 8000)




