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

    ///the Model: saving each property of a morgagae deal
    var morageApplication = MonthlyMorage(amount: 0, numberOfMonths: 30, interestRate: 3.33) {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: - RETURN VALUES
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = String(morageApplication.amount)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ///uses a filter to find any characters that do NOT
        let stringInts = string.filter({ Int(String($0)) == nil })
        if (stringInts).count > 0 {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldAmount.resignFirstResponder() //dismiss keyboard
        
        return true
    }
    
    // MARK: - VOID METHODS
    
    ///refresh or set-up main ui elements such as the month's button and montly payment label
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
    }
    
    // MARK: - IBACTIONS
    @IBOutlet weak var textFieldAmount: UICurrencyTextField!
    
    @IBOutlet weak var buttonMonths: UIButton!
    @IBAction func pressNumberOfMonths(_ sender: Any) {
        /*present text field for number of months*/
        let alertNumberOfMonths = UIAlertController(title: "Number of Months", message: "enter an amount", preferredStyle: .alert)
        alertNumberOfMonths.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        alertNumberOfMonths.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] (action) in
            if let numberOfMonths = UInt(alertNumberOfMonths.textFields!.first!.text ?? "0") {
                self!.morageApplication.numberOfMonths = numberOfMonths
            }
        }))
        alertNumberOfMonths.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertNumberOfMonths, animated: true)
    }
    @IBOutlet weak var sliderMonths: UISlider!
    @IBAction func didChangeMonthSlider(_ sender: Any) {
        /*did slide slider*/
        morageApplication.numberOfMonths = UInt(sliderMonths.value)
    }
    
    @IBOutlet weak var labelMonthlyPayments: UILabel!
    
    @IBAction func tappedOutside(_ sender: Any) {
        textFieldAmount.resignFirstResponder() //dismiss keyboard
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*after the view controller finished loading, update the interface */
        self.updateUI()
    }
}

