//
//  OTPViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 10/31/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import SwiftyJSON

@IBDesignable class OTPViewController: UIViewController, UITextFieldDelegate, MyTextFieldDelegate{
    @IBOutlet weak var codeSentLabel: UILabel!
    func didPressBackspace(textField: MyTextField, txtfieldNumber: Int) {
        print("BACKSPACED")
        print(textField.hasText)
        if(textField.hasText == true){
            print("has text true")
            print(txtfieldNumber)
        }else{
            print("has text false")
            print(txtfieldNumber)
        }
    }
    
    //MARK: Variables
    var email: String = ""
    var member_id: JSON!

    //MARK: Properties
    @IBOutlet weak var field1: UITextField!
    @IBOutlet weak var field2: UITextField!
    @IBOutlet weak var field3: UITextField!
    @IBOutlet weak var field4: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var resendCodeLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var viewContent: UIView!
    
    
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field1.delegate = self
        field2.delegate = self
        field3.delegate = self
        field4.delegate = self
        
        
        codeSentLabel.text = "Enter the code was sent to your \n email: " + email
        print("testing json 2", member_id!)
        
        delayWithSeconds(0.4) {
            self.field1.becomeFirstResponder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        verificationBoxDesign();
        // Do any additional setup after loading the view.
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
    func maxLength (textFieldName: UITextField, max: Int, fieldNumber: Int){
        let length = (textFieldName.text?.count)
        let getFieldValue = textFieldName.text ?? ""
        let splitString = Array(getFieldValue)
        
        if(splitString.count == 2 && fieldNumber != 4){
            switch fieldNumber {
            case 1:
                field2.text = ("\(splitString[1])")
                //field2.isUserInteractionEnabled = true
                field2.becomeFirstResponder()
                //field1.isUserInteractionEnabled = false
            case 2:
                field3.text = ("\(splitString[1])")
               // field3.isUserInteractionEnabled = true
                field3.becomeFirstResponder()
                //field2.isUserInteractionEnabled = false
                
            case 3:
                field4.text = ("\(splitString[1])")
               //field4.isUserInteractionEnabled = true
                field4.becomeFirstResponder()
                //field3.isUserInteractionEnabled = false
                
            default:
                break;
            }
        }
        if(length ?? 0 > max){
            textFieldName.deleteBackward()
        }else{
            
        }
        
    }
    func checkEmptyField(txtfield: UITextField) -> Bool{
        if(txtfield.text?.isEmpty ?? false){
            return true
        }else{
            return false
        }
    }
    
    //MARK: Actions
    @IBAction func field1EditingChanged(_ sender: UITextField) {
        
        maxLength(textFieldName: field1, max: 1, fieldNumber: 1)
        if (checkEmptyField(txtfield: field3) == true) {
            //print("BCK")
            
        }else{
            //print("else")
            
        }
    }
    @IBAction func field2EditingChanged(_ sender: UITextField) {
        didPressBackspace(textField: field2 as! MyTextField, txtfieldNumber: 2)
        if (checkEmptyField(txtfield: field2) == true) {
           // print("BCK")
           // field1.isUserInteractionEnabled = true
            
            
            field1.becomeFirstResponder()
           
            //getEmptyFieldText()
            
            //field2.isUserInteractionEnabled = false
        }else{
            //print("else")
        }
        maxLength(textFieldName: field2, max: 1, fieldNumber: 2)
//        if(field4.text?.count ?? 0 < 1 || field4.text?.count == nil){
//            //didPressBackspace(textField: field4 as! MyTextField)
//            field1.becomeFirstResponder()
//        }else{
//            field2.resignFirstResponder()
//        }
        
    }
    @IBAction func field3EditingChanged(_ sender: UITextField) {
        didPressBackspace(textField: field3 as! MyTextField, txtfieldNumber: 3)
        
        if (checkEmptyField(txtfield: field3) == true) {
            //print("BCK")
           // field2.isUserInteractionEnabled = true
            
            
            field2.becomeFirstResponder()
            //getEmptyFieldText()
            
            
          //  field3.isUserInteractionEnabled = false
            
        }else{
            //print("else")
        }
        
        maxLength(textFieldName: field3, max: 1, fieldNumber: 3)
//        if(field4.text?.count ?? 0 < 1 || field4.text?.count == nil){
//            //didPressBackspace(textField: field4 as! MyTextField)
//            field2.becomeFirstResponder()
//        }else{
//            field3.resignFirstResponder()
//        }
        
    }
    @IBAction func field4EditingChanged(_ sender: UITextField) {
        if (checkEmptyField(txtfield: field4) == true) {
           // print("BCK")
            didPressBackspace(textField: field4 as! MyTextField, txtfieldNumber: 4)
           // field3.isUserInteractionEnabled = true
            
            
            field3.becomeFirstResponder()
            //getEmptyFieldText()
            
            
           // field4.isUserInteractionEnabled = false
        }else{
            //print("else")
        }
        
        maxLength(textFieldName: field4, max: 1, fieldNumber: 4)
        
        
//        if(field4.text?.count ?? 0 < 1 || field4.text?.count == nil){
//            //didPressBackspace(textField: field4 as! MyTextField)
//            field3.becomeFirstResponder()
//        }else{
//            field4.resignFirstResponder()
//        }
        
    }
    
    @IBAction func field1DidBeginEditing(_ sender: UITextField) {
        //field1.becomeFirstResponder()
        //field1.selectAll(nil)
    }
    @IBAction func field2DidBeginEditing(_ sender: UITextField) {
        //field2.becomeFirstResponder()
        //field2.selectAll(nil)
    }
    @IBAction func field3DidBeginEditing(_ sender: UITextField) {
        //field3.becomeFirstResponder()
       // field3.selectAll(nil)
    }
    
    @IBAction func field4DidBeginEditing(_ sender: UITextField) {
        //field4.becomeFirstResponder()
        //field4.selectAll(nil)
    }
    
    
    
    @IBAction func field1TouchUpInside(_ sender: UITextField) {
        getEmptyFieldText()
    }
    
    @IBAction func field2TouchUpInside(_ sender: UITextField) {
        getEmptyFieldText()
    }
    @IBAction func field3TouchUpInside(_ sender: UITextField) {
        getEmptyFieldText()
    }
    @IBAction func field4TouchUpInside(_ sender: UITextField) {
        getEmptyFieldText()
    }
    
    func getEmptyFieldText(){
        
        if(field4.text?.count ?? 0 > 0 && field3.text?.count ?? 0 > 0 && field2.text?.count ?? 0 > 0 && field1.text?.count == 0 ){
            //field1.isUserInteractionEnabled = true
            field1.becomeFirstResponder()
            print("1")
        }else if(field4.text?.count ?? 0 > 0 && field3.text?.count ?? 0 > 0 && field1.text?.count ?? 0 > 0 && field2.text?.count == 0  ){
            //field2.isUserInteractionEnabled = true
            field2.becomeFirstResponder()
            print("2")
        }
        else if(field4.text?.count ?? 0 > 0 && field1.text?.count ?? 0 > 0 && field2.text?.count ?? 0 > 0 && field3.text?.count == 0  ){
           //field3.isUserInteractionEnabled = true
            field3.becomeFirstResponder()
            print("3")
        }
        else if(field1.text?.count ?? 0 > 0 && field3.text?.count ?? 0 > 0 && field2.text?.count ?? 0 > 0 && field4.text?.count == 0 ){
            //field4.isUserInteractionEnabled = true
            field4.becomeFirstResponder()
            print("4")
        }else{
            print("5")
            print(field1.text?.count ?? 0)
        }
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && (keyboardSize.height * 2) > resendCodeLabel.frame.origin.y {
                self.view.frame.origin.y -= (keyboardSize.height * 2) - resendCodeLabel.frame.origin.y + 10
                print("if KeyboardSize: " , (keyboardSize.height * 2) , " resendCodeLabel Y " , resendCodeLabel.frame.origin.y)
                
                
            }else{
                print("else KeyboardSize: " , (keyboardSize.height * 2) , " resendCodeLabel Y " , resendCodeLabel.frame.origin.y)
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
    
    @IBAction func hideKeyboard2(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    func verificationBoxDesign(){
        
        
        let arrayFields = [field1, field2, field3, field4]
        for field in arrayFields {
            field!.layer.borderColor = UIColor.white.cgColor
            field!.layer.cornerRadius = 5
            field!.layer.borderWidth = 1.5;
        }
        confirmButton.layer.cornerRadius = 5
        
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let codetextFieldCombined: String = field1.text! + field2.text! + field3.text! + field4.text!
        if(codetextFieldCombined == "1111"){
        self.performSegue(withIdentifier: "otpToHomePage", sender: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "The OTP entered is incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }

        
        
    }
    

    
}


