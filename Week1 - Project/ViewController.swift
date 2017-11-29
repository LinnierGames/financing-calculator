//
//  ViewController.swift
//  Week1 - Project
//
//  Created by Erick Sanchez on 11/27/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

struct MonthlyMorage {
    var amount: Double
    var numberOfMonths: UInt
    var interestRate: Double
    
    func monthlyPayments() -> Double {
        return (amount + (amount * interestRate) ) / Double(numberOfMonths)
    }
}

class ViewController: UIViewController, UICurrencyTextFieldDelegate {

    var morageApplication = MonthlyMorage(amount: 100000, numberOfMonths: 30, interestRate: 3.33)
    
    // MARK: - RETURN VALUES
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = String(morageApplication.amount)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let stringInts = string.filter({ Int(String($0)) == nil })
        if (stringInts).count > 0 {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldAmount.resignFirstResponder()
        
        return true
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        textFieldAmount.doubleValue = morageApplication.amount
        UIView.setAnimationsEnabled(false)
        UIView.performWithoutAnimation {
            buttonMonths.setTitle("\(morageApplication.numberOfMonths)m", for: .normal)
            buttonMonths.layoutIfNeeded()
        }
        sliderMonths.value = Float(morageApplication.numberOfMonths)
        labelMonthlyPayments.text = String(doubledCurrency: morageApplication.monthlyPayments()) ?? "(null)"
    }
    
    // MARK: Text Field Delegate
    
    func textField(_ textField: UICurrencyTextField, didFinishWithValue doubled: Double) {
        morageApplication.amount = doubled
        updateUI()
    }
    
    // MARK: - IBACTIONS
    @IBOutlet weak var textFieldAmount: UICurrencyTextField!
    @IBOutlet weak var buttonMonths: UIButton!
    @IBAction func pressNumberOfMonths(_ sender: Any) {
        let alertNumberOfMonths = UIAlertController(title: "Number of Months", message: "enter an amount", preferredStyle: .alert)
        alertNumberOfMonths.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        alertNumberOfMonths.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] (action) in
            if let numberOfMonths = UInt(alertNumberOfMonths.textFields!.first!.text ?? "0") {
                self!.morageApplication.numberOfMonths = numberOfMonths
                self!.updateUI()
            }
        }))
        alertNumberOfMonths.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertNumberOfMonths, animated: true)
    }
    @IBOutlet weak var sliderMonths: UISlider!
    @IBAction func didChangeMonthSlider(_ sender: Any) {
        morageApplication.numberOfMonths = UInt(sliderMonths.value)
        updateUI()
    }
    
    @IBOutlet weak var labelMonthlyPayments: UILabel!
    
    @IBAction func tappedOutside(_ sender: Any) {
        textFieldAmount.resignFirstResponder()
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
}

