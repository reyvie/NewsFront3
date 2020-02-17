//
//  fullDetailsOfNewsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/4/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
class fullDetailsOfNewsViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var acknowledgeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    //Story content:
    var titleContent: String = ""
    var content: String = ""
    var created: String = ""
    var age: String = ""
    var acknowledged: String = ""
    var favorite: String = ""
    
    //Images content
    var id: String = ""
    var url: String = ""
    var story_id: String = ""
    
    var storiesData: [StoryModel] = []
    let homeVc = HomeViewController()
    var indexRow = 0
    
    private var storyID: String = ""
    private var json: JSON = []
    private var JSONresults: JSON = []
    
    //USERDEFAULTS
    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
    
    //MARK: OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        convertHtml()
        designButton()
        downloadImg()
        
        //textContent.sizeToFit()
//        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(self.story_id != ""){
            getNewsDetails(story_ID: story_id)
            designButton()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
            vc?.indexpathTable = IndexPath(row: indexRow, section: 0)
            vc?.homeTableView.reloadData()
              
        
    }
    func convertHtml(){
        titleLabel.text = titleContent
        let convertHtmltoString = content.htmlToString
        textContent.text = convertHtmltoString
    }
    func downloadImg(){
        let url = URL(string: self.url)
        self.image.sd_setImage(with: url!, placeholderImage: UIImage(contentsOfFile:"defaultImage.png"))
        self.image.sd_imageIndicator = SDWebImageActivityIndicator.gray
        DispatchQueue.main.async{
            Alamofire.request(url!).response{ response in
                print(response.response?.statusCode ?? 0)
                if(response.response?.statusCode == 404){
                   // cell.myImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.image.sd_imageIndicator = nil
                    self.image.image = UIImage(named: "defaultImage.png")
                }else{
                    self.image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.image.sd_setImage(with: url!, placeholderImage: UIImage(contentsOfFile:"defaultImage.png"))
                }
             }
        }
    }

    func designButton(){
        if(self.favorite == "0"){
            likeButton.setImage(UIImage(named: "Like.png"), for: .normal)
            likeButton.setTitle("Like", for: .normal)
            likeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            likeButton.setImage(UIImage(named: "Liked.png"), for: .normal)
            likeButton.setTitle("Liked", for: .normal)
            likeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        if(self.acknowledged == "0"){
            acknowledgeButton.setImage(UIImage(named: "Acknowledge.png"), for: .normal)
            acknowledgeButton.setTitle("Acknowledge", for: .normal)
            acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            acknowledgeButton.setImage(UIImage(named: "Acknowledged.png"), for: .normal)
            acknowledgeButton.setTitle("Acknowledged", for: .normal)
            acknowledgeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
    }
    
    func getNewsDetails(story_ID: String){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getstories.json") else { return }
        let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story_id": story_ID] as [String : Any]
        //DispatchQueue.main.async{
            Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
             //check if the result has a value
                if response.result.isSuccess {
                    if let JSONResponse = response.result.value as? [String: Any]{
                        self.json = JSON(JSONResponse)
                        self.JSONresults = self.json["results"]
                        self.JSONresults.array?.forEach({ (story) in
                            
                            let story = StoryModel(title: story["Story"]["title"].stringValue, content: story["Story"]["content"].stringValue, created: story["Story"]["created"].stringValue, age: story["Story"]["age"].stringValue, acknowledged: story["Story"]["acknowledged"].stringValue, favorite: story["Story"]["favorite"].stringValue, id: story["Images"][0]["id"].stringValue, url: story["Images"][0]["url"].stringValue, story_id: story["Images"][0]["story_id"].stringValue  )
                            
                            self.storiesData.append(story)
                           // print("Story:\(story)")
                        })
                        //print("no of array: \(self.storiesData.count) results: \(self.storiesData[0].title)")
                    }
                }else{
                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
                }
                
            }
       // }
    }
    
    func AddToFavorites(story_ID: String){
       guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/addtofavorites.json") else { return }
    let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story": story_ID] as [String : Any]
       
//       self.view.isUserInteractionEnabled = false
//       activityIndicator("Please wait...")
//       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
           Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
            //check if the result has a value
               if response.result.isSuccess {
                   if let JSONResponse = response.result.value as? [String: Any]{
                       self.json = JSON(JSONResponse)
                       self.JSONresults = self.json["results"]
                       
                       if(self.JSONresults["success"]).stringValue == "1"{
                          //print("Liked")
                       }else{
                          // print("false \(self.JSONresults["success"])")
                           
                       }
                   }
               }else{
                   print("Alamofire Error: \(response.result.error!.localizedDescription)")
               }
           }
//        self.stopActivityIndicator()
//        self.view.isUserInteractionEnabled = true
//       }
    }

       
   func AcknowledgeStory(story_ID: String){
       guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/acknowledgestory.json") else { return }
    let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story_id": story_ID ] as [String : Any]
    
    self.view.isUserInteractionEnabled = false
    activityIndicator("Please wait...")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
           Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
            //check if the result has a value
               if response.result.isSuccess {
                   if let JSONResponse = response.result.value as? [String: Any]{
                       self.json = JSON(JSONResponse)
                       self.JSONresults = self.json["result"]
                      // print(self.JSONresults)
                       if self.JSONresults.stringValue == "success" {
                          // print("acknowledged")
                       }else{
                           
                       }
                   }
               }else{
                   print("Alamofire Error: \(response.result.error!.localizedDescription)")
               }
            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
           }
        
       }
   }
       
       
   func RemoveFromFavorites(story_ID: String){
       guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/removefromfavorites.json") else { return }
    let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story": story_ID ] as [String : Any]
           Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
               if response.result.isSuccess {
                   if let JSONResponse = response.result.value as? [String: Any]{
                       self.json = JSON(JSONResponse)
                       self.JSONresults = self.json["results"]
                       
                       if(self.JSONresults["success"]).stringValue == "1"{
                        
                       }else{
                           
                       }
                       
                   }
               }else{
                   print("Alamofire Error: \(response.result.error!.localizedDescription)")
               }
           }
   }
    
    
    
    
    //MARK: ACTIONS
    @IBAction func LikeAction(_ sender: UIButton) {
        //print(sender.tag)
        storyID = self.story_id
        
        //print("Story ID: \(storyID)")
        if ( self.favorite == "0") {
            self.favorite = "1"
            AddToFavorites(story_ID: storyID)
        }else{
            self.favorite = "0"
            RemoveFromFavorites(story_ID: storyID)
        }
        designButton()
        //homeVc.homeTableView.reloadData()
        
    }
    
    @IBAction func AcknowledgeAction(_ sender: Any) {
        storyID = self.story_id
        
        if(self.acknowledged == "0"){
            self.acknowledged = "1"
            
            AcknowledgeStory(story_ID: storyID)
            //print("STORYID \(storyID)")
        }
        designButton()
        //homeVc.homeTableView.reloadData()
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


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
