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
        titleLabel.text = titleContent
        let convertHtmltoString = content.htmlToString
        textContent.text = convertHtmltoString
        designButton()
        downloadImg()
        //textContent.sizeToFit()
//        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)

    //        if self.isMovingFromParent {
    //            // Your code...
    //            homeVc.indexpathTable = IndexPath(row: indexRow, section: 0)
    //            print("fdn \(indexRow)")
    //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.story_id != ""){
            getNewsDetails(story_ID: story_id)
            designButton()
        }
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
            vc?.indexpathTable = IndexPath(row: indexRow, section: 0)
            vc?.homeTableView.reloadData()
              
        
    }
    
    
    func downloadImg(){
        let url = URL(string: self.url)
        image.downloadImage(from: url!)
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
        
        
        DispatchQueue.main.async{
            AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
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
        }
    }
    
    
    
    
    func AddToFavorites(story_ID: String){
       guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/addtofavorites.json") else { return }
    let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story": story_ID] as [String : Any]

       DispatchQueue.main.async{
           AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
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
       }
    }

       
   func AcknowledgeStory(story_ID: String){
       guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/acknowledgestory.json") else { return }
    let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story_id": story_ID ] as [String : Any]

       DispatchQueue.main.async{
           AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
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
           }
       }
   }
       
       
   func RemoveFromFavorites(story_ID: String){
       guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/removefromfavorites.json") else { return }
    let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story": story_ID ] as [String : Any]

       DispatchQueue.main.async{
           AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
            //check if the result has a value
               
               if response.result.isSuccess {
                   if let JSONResponse = response.result.value as? [String: Any]{
                       self.json = JSON(JSONResponse)
                       self.JSONresults = self.json["results"]
                       
                       if(self.JSONresults["success"]).stringValue == "1"{
                           //print("Like")
                       }else{
                           //print("false \(self.JSONresults["success"])")
                           
                       }
                       
                   }
               }else{
                   print("Alamofire Error: \(response.result.error!.localizedDescription)")
               }
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
