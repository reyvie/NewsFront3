//
//  ViewController.swift
//  NewsFront3
//
//  Created by ReyvieB on 10/25/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var lblValidationMsg: UILabel!
    
    @IBAction func HideKeyboard(_ sender: Any) {
        EmailTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ButtonDesign()
        //bgGradient()
    }

    func ButtonDesign(){
        RegisterButton.layer.cornerRadius = 3
        EmailTextField.layer.cornerRadius = 3
        EmailTextField.layer.borderWidth = 1.5;
        EmailTextField.layer.borderColor = UIColor.white.cgColor
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func bgGradient(){
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.darkGray, UIColor.blue.cgColor]
        newLayer.frame = view.frame
        view.layer.insertSublayer(newLayer, at: 1)
    }

    @IBAction func registerValidation(_ sender: UIButton) {
        lblValidationMsg.isHidden = true
        
        guard let email = EmailTextField.text, EmailTextField.text?.characters.count != 0 else {
            lblValidationMsg.text = "Please enter your email"
            lblValidationMsg.isHidden = false
            return }
        
        if isValidEmail(emailID: email) == false {
            lblValidationMsg.isHidden = false
            lblValidationMsg.text = "Please enter valid email address"
        }
    }
    

    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
}

