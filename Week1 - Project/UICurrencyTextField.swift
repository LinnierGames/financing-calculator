//
//  UICurrencyTextField.swift
//  Week1 - Project
//
//  Created by Erick Sanchez on 11/28/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

@objc
protocol UICurrencyTextFieldDelegate: UITextFieldDelegate {
    @objc optional func textField(_ textField: UICurrencyTextField, didFinishWithValue doubled: Double)
}

class UICurrencyTextField: UITextField, UITextFieldDelegate {
    
    /*
     e.g. value = 123, then text is $1.23
     */
    public var value: Int = 0 {
        didSet {
            updateText()
        }
    }
    
    public var doubleValue: Double {
        get {
            let doubled = Double(value)
            
            return doubled/100.0
        }
        set {
            value = Int(doubleValue * 100.0)
        }
    }
    
    @IBOutlet public weak var currencyDelegate: UICurrencyTextFieldDelegate?
    
    // MARK: - RETURN VALUES
    
    init(doubledValue: Double, delegate: UICurrencyTextFieldDelegate) {
        super.init(frame: CGRect())
        
        //TODO: map doubledValue to a decimal-less int
        self.currencyDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        keyboardType = .numberPad
        delegate = self
    }
    
    // MARK: - VOID METHODS
    
    private func updateText() {
        text = String(doubledCurrency: doubleValue)!
    }
    
    // MARK: Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// a string that contains non-integers
        let stringInts = string.filter({ Int(String($0)) == nil })
        if (stringInts).count > 0 { //Contains a non-int
            return false
        } else { //all ints, or backspace
            if string != "" {
                let collectionOfInts = string
                var stringValue = String(value)
                stringValue += collectionOfInts
                if let newValue = Int(stringValue) { //can overflow
                    value = newValue
                }
            } else { //Backspace
                value = value / 10
            }
            updateText()
            
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currencyDelegate?.textField?(self, didFinishWithValue: doubleValue)
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
}
