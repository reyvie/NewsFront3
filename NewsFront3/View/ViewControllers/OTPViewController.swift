//
//  OTPViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 10/31/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


@IBDesignable class OTPViewController: UIViewController, UITextFieldDelegate, MyTextFieldDelegate{
    @IBOutlet weak var codeSentLabel: UILabel!

    //MARK: Variables
    var email: String = ""
    var member_id: JSON = []
    var token_id: JSON = []
    
    //MARK: Properties
    @IBOutlet weak var field1: UITextField!
    @IBOutlet weak var field2: UITextField!
    @IBOutlet weak var field3: UITextField!
    @IBOutlet weak var field4: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    
    
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field1.delegate = self
        field2.delegate = self
        field3.delegate = self
        field4.delegate = self
        
        verificationBoxDesign()
        
        delayWithSeconds(0.1) {
            self.field1.becomeFirstResponder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
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
    
    func maxLength (textFieldName: UITextField, max: Int, fieldNumber: Int){
        let length = (textFieldName.text?.count)
        let getFieldValue = textFieldName.text ?? ""
        let splitString = Array(getFieldValue)
        
        if(splitString.count == 2 && fieldNumber != 4){
            switch fieldNumber {
            case 1:
                field2.text = ("\(splitString[1])")
                field2.becomeFirstResponder()
            case 2:
                field3.text = ("\(splitString[1])")
                field3.becomeFirstResponder()
                
            case 3:
                field4.text = ("\(splitString[1])")
                field4.becomeFirstResponder()
            default:
                break;
            }
        }
        
        if(length ?? 0 > max){
            textFieldName.deleteBackward()
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
            field1.becomeFirstResponder()
        }
        maxLength(textFieldName: field2, max: 1, fieldNumber: 2)
        
    }
    @IBAction func field3EditingChanged(_ sender: UITextField) {
        didPressBackspace(textField: field3 as! MyTextField, txtfieldNumber: 3)
        if (checkEmptyField(txtfield: field3) == true) {
            field2.becomeFirstResponder()
        }
        maxLength(textFieldName: field3, max: 1, fieldNumber: 3)
    }
    @IBAction func field4EditingChanged(_ sender: UITextField) {
        if (checkEmptyField(txtfield: field4) == true) {
            didPressBackspace(textField: field4 as! MyTextField, txtfieldNumber: 4)
            field3.becomeFirstResponder()
        }
        maxLength(textFieldName: field4, max: 1, fieldNumber: 4)
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
            if self.view.frame.origin.y == 0 && (keyboardSize.height * 2) > resendCodeBtn.frame.origin.y {
                self.view.frame.origin.y -= (keyboardSize.height * 2) - resendCodeBtn.frame.origin.y + 10
                print("if KeyboardSize: " , (keyboardSize.height * 2) , " resendCodeLabel Y " , resendCodeBtn.frame.origin.y)
            }else{
                print("else KeyboardSize: " , (keyboardSize.height * 2) , " resendCodeLabel Y " , resendCodeBtn.frame.origin.y)
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
        codeSentLabel.text = "Enter the code was sent to your \n email: \(email)"
        let arrayFields  = [UITextField] (arrayLiteral: field1, field2, field3, field4)
        
        for field in arrayFields {
            field.layer.borderColor = UIColor.white.cgColor
            field.layer.cornerRadius = 5
            field.layer.borderWidth = 1.5;
        }
        confirmButton.layer.cornerRadius = 5
        
    }
    
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let codetextFieldCombined: String = field1.text! + field2.text! + field3.text! + field4.text!
        
        var json: JSON = []
        var JSONresults: JSON = []
        var isSuccess: JSON = []
        var token: JSON = []
        
        
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/login.json") else { return }
        let params = ["member_id": member_id, "code": codetextFieldCombined] as [String : Any]
        
        Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{
            (response) -> Void in
             //check if the result has a value
            if let JSONResponse = response.result.value as? [String: Any]{
                json = JSON(JSONResponse)
                JSONresults = json["results"]
                isSuccess = JSONresults["success"]
                token = JSONresults["token"]
                self.token_id = token
                //self.memberID = getMemberID
                print("isSuccess: \(isSuccess)")
            }
            
            if(isSuccess == "success"){
                self.saveUserPreference()
                self.performSegue(withIdentifier: "otpToHomePage", sender: nil)
            }else{
                let alert = UIAlertController(title: "Error", message: "The OTP entered is incorrect", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        
    }
    
    }

    
    
    @IBAction func resendCodeAction(_ sender: UIButton) {
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/register.json") else { return }
        let params = ["username": self.email]
        
        activityIndicator("Please wait")
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{
                (response) -> Void in
                 //check if the result has a value
                self.stopActivityIndicator()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    func activityIndicator(_ title: String) {

        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()

        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 50)
       // effectView.frame = CGRect(x: view.frame.midX, y: view.frame.midY , width: 50, height: 50)
        effectView.layer.cornerRadius = 10
        effectView.layer.masksToBounds = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()

        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopActivityIndicator(){
        self.activityIndicator.stopAnimating()
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     //   if segue.identifier == "otpToHomePage"
      //  {
//            let tabVc = segue.destination as! UITabBarController
//            let navVc = tabVc.viewControllers!.first as! UINavigationController
//            let homeVc = navVc.viewControllers.first as! HomeViewController
//
//           // homeVc.token = self.token_id
//           // homeVc.member_id = self.member_id
//
//            print("contr id : \(homeVc.token): selfmemberID:\(self.token_id)")
       // }
    }
    
    func saveUserPreference(){
        UserDefaults.standard.set(self.token_id.stringValue, forKey: "token")
        UserDefaults.standard.set(self.member_id.stringValue, forKey: "member_id")
    }
    
    

}
