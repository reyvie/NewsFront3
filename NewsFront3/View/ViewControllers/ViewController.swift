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
    
   //var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func HideKeyboard(_ sender: Any) {
        EmailTextField.resignFirstResponder()
    }
    
    private let networkingClient = NetworkingClient()
    
    //var actIndi:UIActivityIndicatorView = UIActivityIndicatorView()
    var memberID: JSON = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //EmailTextField.becomeFirstResponder()
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
        //lblValidationMsg.isHidden = true
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    
    
    @IBAction func emailTextFieldEditingChanged(_ sender: UITextField) {
    correctFormatDesign()
    lblValidationMsg.isHidden = true
    }
    
    @IBAction func emailTextFieldDidEditingBegin(_ sender: UITextField) {

    }
    @IBAction func registerValidation(_ sender: UIButton) {
//        actIndi.center = self.view.center
//        actIndi.style = UIActivityIndicatorView.Style.whiteLarge
//        actIndi.backgroundColor = .darkGray
//        //actIndi.backgroundColor = UIColor
//        actIndi.hidesWhenStopped = true
//        view.addSubview(actIndi)
        
        
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/register.json") else { return }
        let params = ["username": EmailTextField.text]
        
        var json: JSON!
        var JSONresults: JSON!
        var isSuccess: JSON!
        var getMemberID: JSON!
        
        
        if(EmailTextField.text == ""){
            self.lblValidationMsg.isHidden = false
            self.lblValidationMsg.text = "Please enter valid email address"
            self.errorDesign()
            self.EmailTextField.shake()
        }else{
        
        activityIndicator("Please wait")
            DispatchQueue.main.async {
                AF.request(urlToExecute, method: .post, parameters: params).responseJSON{
                    (response) -> Void in
                     //check if the result has a value
                    if let JSONResponse = response.result.value as? [String: Any]{
                         json = JSON(JSONResponse)
                         JSONresults = json["results"]
                         isSuccess = JSONresults["success"]
                         getMemberID = JSONresults["member_id"]
                         self.memberID = getMemberID
                    }
                    
                    
                    guard let email = self.EmailTextField.text, self.EmailTextField.text?.count != 0 else {
                        self.lblValidationMsg.text = "Please enter your email"
                        self.lblValidationMsg.isHidden = false
                        self.errorDesign()
                        self.EmailTextField.shake()

                        return
                        
                    }
                   // print(isSuccess!)
                    if self.isValidEmail(emailID: email) == false || isSuccess != "success"{
                        self.lblValidationMsg.isHidden = false
                        self.lblValidationMsg.text = "Please enter valid email address"
                        self.errorDesign()
                        self.EmailTextField.shake()

                    }else {
                        
                        self.delayWithSeconds(0.5){
                            //
                        }
                        self.performSegue(withIdentifier: "PushToOTPSegue", sender: nil)
                        self.memberID = getMemberID
                        
                        self.correctFormatDesign()
                    }
                        print("testing json 1" , self.memberID)
                        
                    //self.actIndi.stopAnimating()
                    //self.activityIndicator.stopAnimating()
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.stopActivityIndicator()
                }
            }
       // actIndi.startAnimating()
        
        }
        

        //self.actIndi.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
        
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
