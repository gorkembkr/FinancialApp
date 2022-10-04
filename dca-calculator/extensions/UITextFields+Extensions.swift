//
//  UITextFields+Extensions.swift
//  dca-calculator
//
//  Created by Gorkem BekAr on 4.03.2022.
//

import UIKit

extension UITextField {
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar = UIToolbar(frame: .init(x: 0 , y: 0 , width: screenWidth , height: 50))
        doneToolBar.barStyle = .default
        let flexBarButtonItems = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let items = [flexBarButtonItems , doneButtonItem]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    
    @objc private func dismissKeyboard(){
        resignFirstResponder()
    }
}
