//
//  ViewController.swift
//  NewsFront3
//
//  Created by ReyvieB on 10/25/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var lblValidationMsg: UILabel!
    
    @IBAction func HideKeyboard(_ sender: Any) {
        EmailTextField.resignFirstResponder()
    }
    
    private let networkingClient = NetworkingClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ButtonDesign()
        bgGradient()
        lblValidationMsg.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && (keyboardSize.height * 2) > RegisterButton.frame.origin.y {
                self.view.frame.origin.y -= (keyboardSize.height * 2) - RegisterButton.frame.origin.y + 20
//                print("label height: ", RegisterButton.frame.origin.y , "  keyboardSize height:" , (keyboardSize.height*2), "diff: ", (RegisterButton.frame.origin.y - (keyboardSize.height*2)) )
            }else{
//                print("2label height: ", RegisterButton.frame.origin.y , "  keyboardSize height:" , (keyboardSize.height*2), "diff: ", (RegisterButton.frame.origin.y - (keyboardSize.height*2)))
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    
    
    
    func ButtonDesign(){
        RegisterButton.layer.cornerRadius = 5
        EmailTextField.layer.cornerRadius = 5
        EmailTextField.layer.borderWidth = 1.5;
        EmailTextField.layer.borderColor = UIColor.white.cgColor
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func bgGradient(){
    
        let color1 = hexStringToUIColor(hex: "#8C9800")
        let color2 = hexStringToUIColor(hex: "#31C5E4")
        
        
        let newLayer = CAGradientLayer()
        newLayer.colors = [color1, color2]
        newLayer.frame = view.frame
        view.layer.insertSublayer(newLayer, at: 1)
    }

    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    func errorDesign() {
        EmailTextField.layer.borderColor = UIColor.red.cgColor
                EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        lblValidationMsg.textColor = UIColor.red
    }
    func correctFormatDesign(){
        EmailTextField.layer.borderColor = UIColor.white.cgColor
        lblValidationMsg.textColor = UIColor.white
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    
    
    
    @IBAction func registerValidation(_ sender: UIButton) {
        lblValidationMsg.isHidden = true
        
        guard let email = EmailTextField.text, EmailTextField.text?.count != 0 else {
            lblValidationMsg.text = "Please enter your email"
            lblValidationMsg.isHidden = false
            errorDesign()
            return }
        
        if isValidEmail(emailID: email) == false {
            lblValidationMsg.isHidden = false
            lblValidationMsg.text = "Please enter valid email address"
            errorDesign()
            
            
        }else {
            
            self.performSegue(withIdentifier: "PushToOTPSegue", sender: nil)
            
            correctFormatDesign()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushToOTPSegue"
        {
            let controller = segue.destination as! OTPViewController
            controller.email = EmailTextField.text!
            guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/register.json") else { return }
            let params = ["username": EmailTextField.text]
            
            AF.request(urlToExecute, method: .post, parameters: params).responseJSON{
                (response) -> Void in
                 //check if ther result has a value
                if let JSONResponse = response.result.value as? [String: Any]{
                    let json = JSON(JSONResponse)
                    let JSONresults = json["results"]
                    
                    let isSuccess = JSONresults["success"]
                    let getMemberID = JSONresults["member_id"]
                    
                    
                    print(isSuccess)


                }
                
            }
            
        }
    }
    

}

