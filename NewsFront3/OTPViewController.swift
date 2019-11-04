//
//  OTPViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 10/31/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

@IBDesignable class OTPViewController: UIViewController, UITextFieldDelegate{
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
        
        verificationBoxDesign();
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
        
        if(field2.text?.count ?? 0 < 1 || field2.text?.count == nil){
            field1.becomeFirstResponder()
        }else{
            field3.becomeFirstResponder()
        }
    }
    @IBAction func field3EditingChanged(_ sender: UITextField) {
        maxLength(textFieldName: field3, max: 1)
        
        if(field3.text?.count ?? 0 < 1 || field3.text?.count == nil){
            field2.becomeFirstResponder()
        }else{
            field4.becomeFirstResponder()
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
            if self.view.frame.origin.y == 0 && (keyboardSize.height * 1.5) > resendCodeLabel.frame.origin.y {
                self.view.frame.origin.y -= (keyboardSize.height * 1.5) - resendCodeLabel.frame.origin.y
                print("4label height: ", resendCodeLabel.frame.origin.y , "  keyboardSize height:" , (keyboardSize.height*1.5), "diff: ", (resendCodeLabel.frame.origin.y - (keyboardSize.height * 1.5)) )
            }else{
                print("6label height: ", resendCodeLabel.frame.origin.y , "  keyboardSize height:" , (keyboardSize.height*1.5), "diff: ", (resendCodeLabel.frame.origin.y - (keyboardSize.height * 1.5)) )
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
    
    func verificationBoxDesign(){
        field1.layer.borderColor = UIColor.white.cgColor
        field2.layer.borderColor = UIColor.white.cgColor
        field3.layer.borderColor = UIColor.white.cgColor
        field4.layer.borderColor = UIColor.white.cgColor
        
        field1.layer.cornerRadius = 5
        field2.layer.cornerRadius = 5
        field3.layer.cornerRadius = 5
        field4.layer.cornerRadius = 5
        
        field1.layer.borderWidth = 1.5;
        field2.layer.borderWidth = 1.5;
        field3.layer.borderWidth = 1.5;
        field4.layer.borderWidth = 1.5;
        
        confirmButton.layer.cornerRadius = 5
        
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let codetextFieldCombined: String = field1.text! + field2.text! + field3.text! + field4.text!
        
        print(codetextFieldCombined)
        
        if(codetextFieldCombined == "1111"){
        self.performSegue(withIdentifier: "otpToHomePage", sender: nil)
        }

        
        
    }
}
