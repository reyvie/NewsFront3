//
//  MyTextField.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/6/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

protocol MyTextFieldDelegate : UITextFieldDelegate {
    func didPressBackspace(textField : MyTextField, txtfieldNumber: Int)
}

class MyTextField: UITextField {

    override func deleteBackward() {
        super.deleteBackward()

        // If conforming to our extension protocol
        if let pinDelegate = self.delegate as? MyTextFieldDelegate {
            pinDelegate.didPressBackspace(textField: self, txtfieldNumber: 0)
        }
    }
}


