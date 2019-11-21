//
//  LikeViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/5/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//



import UIKit
import SwiftyJSON
import Alamofire
class LikeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {

    @IBOutlet weak var likeTableView: UITableView!
    var likesData: [LikeModel] = []
    
    private var storyID: String = ""
    private var json: JSON = []
    private var JSONresults: JSON = []
    
    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fetchLikesData()
        }
        self.likeTableView.reloadData()
    }
    
    func fetchLikesData(){
        self.likesData.removeAll()
        
           guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getfavorites.json") else { return }
           let params = ["APIkey": token!, "member_id": member_id!] as [String : Any]
               AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
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
                           self.likeTableView.reloadData()
                           
                           
                           //print("no of array: \(self.storiesData.count) results: \(self.storiesData[0].title)")
                       }
                    
                   }else{
                       print("Alamofire Error: \(response.result.error!.localizedDescription)")
                    
                   }

                   
               }
        self.stopActivityIndicator()
        
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.likeTableView.showEmptyListMessage("")
//
//        if self.likesData.count == 0 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//                self.likeTableView.showEmptyListMessage("You don't have any liked news yet.")
//                print("if \(self.likesData.count)")
//            }
//
//        }else{
//            print("else \(self.likesData.count)")
//            self.likeTableView.showEmptyListMessage(" ")
//
//        }
        return (self.likesData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath) as! LikeTableViewCell

        
        if(self.likesData[indexPath.row].favorite == "1"){
            let url = URL(string: self.likesData[indexPath.row].url)
            cell.prototypeImage.downloadImage(from: url!)
            cell.prototypeLabel.text = self.likesData[indexPath.row].title
            
            cell.dateAndTimePostedLabel.text = self.likesData[indexPath.row].age
            cell.likeButton.tag = indexPath.row
            cell.likeButton.setImage(UIImage(named: "Liked.png"), for: .normal)
            cell.likeButton.setTitle("Liked", for: .normal)
            cell.acknowledgeButton.tag = indexPath.row
            //print("acknowledge: \(self.likesData[indexPath.row].acknowledged)")
            if(self.likesData[indexPath.row].acknowledged == "0"){
                cell.acknowledgeButton.setTitle("Acknowledge", for: .normal)
                cell.acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
                cell.acknowledgeButton.setImage(UIImage(named: "Acknowledge.png"), for: .normal)
            }else{
                cell.acknowledgeButton.setTitle("Acknowledged", for: .normal)
                cell.acknowledgeButton.setTitleColor(UIColor.systemBlue, for: .normal)
                cell.acknowledgeButton.setImage(UIImage(named: "Acknowledged.png"), for: .normal)
            }
            
        } else{
//            cell.isHidden = true
            
        }
        
        return (cell)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        self.likeTableView.reloadData()
//        print("Reload")
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LikeViewController")
//
//        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
    
    func AcknowledgeStory(story_ID: String){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/acknowledgestory.json") else { return }
        let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story_id": story_ID] as [String : Any]
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
    
    
    func RemoveFromFavorites(story_ID: String){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/removefromfavorites.json") else { return }
        let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "story": story_ID] as [String : Any]
        
            AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
             //check if the result has a value
                
                    if let JSONResponse = response.result.value as? [String: Any]{
                        if response.result.isSuccess {
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
                self.stopActivityIndicator()
            }
        //self.likesData.removeAll()
        self.likeTableView.reloadData()
    
    }
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    func activityIndicator(_ title: String) {

        self.strLabel.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.effectView.removeFromSuperview()

        self.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        self.strLabel.text = title
        self.strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        self.strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

        self.effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 50)
       // effectView.frame = CGRect(x: view.frame.midX, y: view.frame.midY , width: 50, height: 50)
        self.effectView.layer.cornerRadius = 10
        self.effectView.layer.masksToBounds = true
        self.activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.startAnimating()

        self.effectView.contentView.addSubview(activityIndicator)
        self.effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopActivityIndicator(){
        self.activityIndicator.stopAnimating()
        self.strLabel.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.effectView.removeFromSuperview()
        
    }
    
    
    @IBAction func handleLike(_ sender: UIButton) {
       self.storyID = self.likesData[sender.tag].story_id
        //print("Story ID: \(storyID)")
        if ( self.likesData[sender.tag].favorite == "1") {
            
            self.likesData[sender.tag].favorite = "0"
            self.RemoveFromFavorites(story_ID: self.storyID)
            //print("removed \(self.storyID)")
            //print(self.JSONresults)
        }
        
        self.activityIndicator("Please wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Change `2.0` to the desired number of seconds.
           
            // Code you want to be delayed
            self.fetchLikesData()
        }

        
        
    }

    
    @IBAction func handleAcknowledge(_ sender: UIButton) {
        //self.storyID = self.likesData[sender.tag].story_id
      
      if(self.likesData[sender.tag].acknowledged == "0"){
          self.likesData[sender.tag].acknowledged = "1"
        self.AcknowledgeStory(story_ID: self.likesData[sender.tag].story_id)
          //print("STORYID \(storyID)")
      }
//        likesData.removeAll()
//        fetchLikesData()

        
  }
    
    
}

extension UIScrollView {
    func showEmptyListMessage(_ message:String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()

        if let `self` = self as? UITableView {
            self.backgroundView = messageLabel
            self.separatorStyle = .none
        } else if let `self` = self as? UICollectionView {
            self.backgroundView = messageLabel
        }
    }
}
