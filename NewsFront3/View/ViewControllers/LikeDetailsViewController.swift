//
//  LikeDetailsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/21/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
class LikeDetailsViewController: UIViewController {
    //MARK: VARIABLES
    var indexRow = 0
    var likesData: [LikeModel] = []
    let likeVc = LikeViewController()
    
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
    
    private var storyID: String = ""
    private var json: JSON = []
    private var JSONresults: JSON = []
    
    //USERDEFAULTS
    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
    
    //MARK: PROPERTIES
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var acknowledgeBtn: UIButton!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var likeContent: UILabel!
    @IBOutlet weak var likeTitle: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convertHtml()
        designButton()
        downloadImg()
        ageLabel.text = self.age
        // Do any additional setup after loading the view.
        
    }
    func designContent(){
        
    }
    func convertHtml(){
        likeTitle.text = titleContent
        let convertHtmltoString = content.htmlToString
        likeContent.text = convertHtmltoString
    }
    func downloadImg(){
        let url = URL(string: self.url)
        self.likeImage.sd_setImage(with: url!, placeholderImage: UIImage(contentsOfFile:"defaultImage.png"))
        self.likeImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        DispatchQueue.main.async{
            Alamofire.request(url!).response{ response in
                print(response.response?.statusCode ?? 0)
                if(response.response?.statusCode == 404){
                   // cell.myImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.likeImage.sd_imageIndicator = nil
                    self.likeImage.image = UIImage(named: "defaultImage.png")
                }else{
                    self.likeImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.likeImage.sd_setImage(with: url!, placeholderImage: UIImage(contentsOfFile:"defaultImage.png"))
                }
             }
        }
        
        
    }
    func designButton(){
        if(self.favorite == "0"){
            likeBtn.setImage(UIImage(named: "Like.png"), for: .normal)
            likeBtn.setTitle("Like", for: .normal)
            likeBtn.setTitleColor(UIColor.black, for: .normal)
        }else{
            likeBtn.setImage(UIImage(named: "Liked.png"), for: .normal)
            likeBtn.setTitle("Liked", for: .normal)
            likeBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        if(self.acknowledged == "0"){
            acknowledgeBtn.setImage(UIImage(named: "Acknowledge.png"), for: .normal)
            acknowledgeBtn.setTitle("Acknowledge", for: .normal)
            acknowledgeBtn.setTitleColor(UIColor.black, for: .normal)
        }else{
            acknowledgeBtn.setImage(UIImage(named: "Acknowledged.png"), for: .normal)
            acknowledgeBtn.setTitle("Acknowledged", for: .normal)
            acknowledgeBtn.setTitleColor(UIColor.systemBlue, for: .normal)
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
                            
                            let story = LikeModel(title: story["Story"]["title"].stringValue, content: story["Story"]["content"].stringValue, created: story["Story"]["created"].stringValue, age: story["Story"]["age"].stringValue, acknowledged: story["Story"]["acknowledged"].stringValue, favorite: story["Story"]["favorite"].stringValue, id: story["Images"][0]["id"].stringValue, url: story["Images"][0]["url"].stringValue, story_id: story["Images"][0]["story_id"].stringValue  )
                            
                            self.likesData.append(story)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    
    
    //MARK: ACTIONS
    
 
    @IBAction func LikebtnAction(_ sender: UIButton) {
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
    
    @IBAction func AcknowledgebtnAction(_ sender: UIButton) {
        storyID = self.story_id
        
        if(self.acknowledged == "0"){
            self.acknowledged = "1"
            
            AcknowledgeStory(story_ID: storyID)
            //print("STORYID \(storyID)")
        }
        designButton()
        //homeVc.homeTableView.reloadData()
    }
    
    
}
