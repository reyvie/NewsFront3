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
    
    private let networkingClient = NetworkingClient()
    
    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
    var memberID: JSON = []
    
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var lblValidationMsg: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(token!)
        print(member_id!)
//        UserDefaults.standard.set("291b1c278bd2abb45ec002331ba0d3db6e589bc7", forKey: "token")
//        UserDefaults.standard.set("66", forKey: "member_id")
        print(token!)
        print(member_id!)
        checkToken()
        ButtonDesign()
        bgGradient()
        lblValidationMsg.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushToOTPSegue"
        {   
            let controller = segue.destination as! OTPViewController
            controller.email = EmailTextField.text!
            controller.member_id = self.memberID
            print("self memberID", self.memberID)
            print("Controller id" ,controller.member_id)
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && (keyboardSize.height * 2) > RegisterButton.frame.origin.y {
                self.view.frame.origin.y -= (keyboardSize.height * 2) - RegisterButton.frame.origin.y + 20
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
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
        //lblValidationMsg.isHidden = true
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func checkToken(){
        if(token != "" && member_id != ""){
            DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "loginToHome", sender: nil)
            })
        }
    }
    @IBAction func HideKeyboard(_ sender: Any) {
        EmailTextField.resignFirstResponder()
    }
    
    @IBAction func emailTextFieldEditingChanged(_ sender: UITextField) {
        correctFormatDesign()
        lblValidationMsg.isHidden = true
    }
    
    
    @IBAction func registerValidation(_ sender: UIButton) {
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/register.json") else { return }
        let params = ["username": EmailTextField.text!]
        
        var json: JSON!
        var JSONresults: JSON!
        var isSuccess: JSON!
        var getMemberID: JSON!
        print(params)
        
        if(EmailTextField.text == ""){
            self.lblValidationMsg.isHidden = false
            self.lblValidationMsg.text = "Please fill out the email text field"
            self.errorDesign()
            self.EmailTextField.shake()
        }else{
            activityIndicator("Please wait")
            view.isUserInteractionEnabled = false
            //DispatchQueue.main.async {
            
            Alamofire.request(urlToExecute, method: .post, parameters: params)
                .validate(statusCode: 200..<300)
                .responseJSON {
                    response in
                    
                    if let JSONResponse = response.result.value as? [String: Any]{
                         json = JSON(JSONResponse)
                         JSONresults = json["results"]
                         isSuccess = JSONresults["success"]
                         getMemberID = JSONresults["member_id"]
                         self.memberID = getMemberID
                        print("JSON")
                        print(JSON(JSONResponse))
                    }
                    
                    switch response.result {
                    case .success(let value):
                        self.performSegue(withIdentifier: "PushToOTPSegue", sender: nil)
                        self.memberID = getMemberID
                        
                        self.correctFormatDesign()
                    case .failure(let error):
                        if (response.data?.count)! > 0 {
                            self.lblValidationMsg.isHidden = false
                            self.lblValidationMsg.text = "Please enter valid email address"
                            self.errorDesign()
                            self.EmailTextField.shake()
                            print(error)
                            
                        }
                        
                    }
                self.stopActivityIndicator()
                self.view.isUserInteractionEnabled = true
            }
            
            
            
                Alamofire.request(urlToExecute, method: .post, parameters: params as Parameters).responseJSON{
                    (response) -> Void in
                     //check if the result has a value
                    if let JSONResponse = response.result.value as? [String: Any]{
                         json = JSON(JSONResponse)
                         JSONresults = json["results"]
                         isSuccess = JSONresults["success"]
                         getMemberID = JSONresults["member_id"]
                         self.memberID = getMemberID
                        print("JSON")
                        print(JSON(JSONResponse))
                    }
                    if (isSuccess != "success"){
                        print("IS SUCESS?! \(response)")
                        self.lblValidationMsg.isHidden = false
                        self.lblValidationMsg.text = "Please enter valid email address"
                        self.errorDesign()
                        self.EmailTextField.shake()
                    }else {
                        self.performSegue(withIdentifier: "PushToOTPSegue", sender: nil)
                        self.memberID = getMemberID
                        
                        self.correctFormatDesign()
                    }
                        print("testing json 1" , self.memberID)
                        
                    //self.actIndi.stopAnimating()
                    //self.activityIndicator.stopAnimating()
                    
                    
                    self.stopActivityIndicator()
                    self.view.isUserInteractionEnabled = true
                }
            //}

        
        }
        
        
    }
    


    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
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
    
    

}

extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 7, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 7, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }

}
