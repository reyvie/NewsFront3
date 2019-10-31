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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field1.delegate = self
        field2.delegate = self
        field3.delegate = self
        field4.delegate = self
        field1.becomeFirstResponder()
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
        field1.selectAll(nil)
    }
    @IBAction func field2DidBeginEditing(_ sender: UITextField) {
        field2.selectAll(nil)
    }
    @IBAction func field3DidBeginEditing(_ sender: UITextField) {
        field3.selectAll(nil)
    }
    
    @IBAction func field4DidBeginEditing(_ sender: UITextField) {
        field4.selectAll(nil)
    }
    
    
}
