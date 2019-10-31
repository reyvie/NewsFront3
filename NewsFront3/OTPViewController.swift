//
//  OTPViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 10/31/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate{
    //MARK: Properties
    @IBOutlet weak var field1: UITextField!
    @IBOutlet weak var field2: UITextField!
    @IBOutlet weak var field3: UITextField!
    @IBOutlet weak var field4: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var resendCodeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        field1.delegate = self
        field2.delegate = self
        field3.delegate = self
        field4.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func maxLength (textFieldName: UITextField, max: Int){
        let length = (textFieldName.text?.count)
        if(length ?? 0 > max){
            //textFieldName.text.
            textFieldName.deleteBackward()
        }
        
    }

    //MARK: Actions
    @IBAction func field1EditingChanged(_ sender: UITextField) {
        maxLength(textFieldName: field1, max: 1)
        if(field1.text?.count ?? 0 < 1 ){
            
        }else{
            field2.becomeFirstResponder()
        }
    }
    @IBAction func field2EditingChanged(_ sender: UITextField) {
        maxLength(textFieldName: field2, max: 1)
        field3.becomeFirstResponder()
        if(field2.text?.count ?? 0 < 1 || field2.text?.count == nil){
            field1.becomeFirstResponder()
        }
    }
    @IBAction func field3EditingChanged(_ sender: UITextField) {
        maxLength(textFieldName: field3, max: 1)
        field4.becomeFirstResponder()
        if(field3.text?.count ?? 0 < 1 || field3.text?.count == nil){
            field2.becomeFirstResponder()
        }
    }
    @IBAction func field4EditingChanged(_ sender: UITextField) {
        maxLength(textFieldName: field4, max: 1)
        if(field4.text?.count ?? 0 < 1 || field4.text?.count == nil){
            field3.becomeFirstResponder()
        }else{
            //field4.resignFirstResponder()
        }
        
    }
    
    @IBAction func field1DidBeginEditing(_ sender: UITextField) {
        field1.becomeFirstResponder()
        field1.selectAll(nil)
    }
    @IBAction func field2DidBeginEditing(_ sender: UITextField) {
        field2.becomeFirstResponder()
        field2.selectAll(nil)
    }
    @IBAction func field3DidBeginEditing(_ sender: UITextField) {
        field3.becomeFirstResponder()
        field3.selectAll(nil)
    }
    
    @IBAction func field4DidBeginEditing(_ sender: UITextField) {
        field4.becomeFirstResponder()
        field4.selectAll(nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && (keyboardSize.height * 1.7) > resendCodeLabel.frame.origin.y {
                self.view.frame.origin.y -= (keyboardSize.height * 1.7) - resendCodeLabel.frame.origin.y
                print("4label height: ", resendCodeLabel.frame.origin.y , "  keyboardSize height:" , (keyboardSize.height*1.7), "diff: ", (resendCodeLabel.frame.origin.y - (keyboardSize.height*1.7)) )
            }else{
                print("6label height: ", resendCodeLabel.frame.origin.y , "  keyboardSize height:" , (keyboardSize.height*1.7), "diff: ", (resendCodeLabel.frame.origin.y - (keyboardSize.height*1.7)) )
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
}
