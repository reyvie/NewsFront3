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
    
   
    @IBAction func HideKeyboard(_ sender: Any) {
        EmailTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.darkGray, UIColor.blue.cgColor]
        newLayer.frame = view.frame

        view.layer.insertSublayer(newLayer, at: 1)
        
        RegisterButton.layer.cornerRadius = 3
        EmailTextField.layer.cornerRadius = 3
        EmailTextField.layer.borderWidth = 1.5;
        EmailTextField.layer.borderColor = UIColor.white.cgColor
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }



}

