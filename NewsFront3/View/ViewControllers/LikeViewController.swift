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
        fetchUsersData()
        likeTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func fetchUsersData(){
           guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getfavorites.json") else { return }
           let params = ["APIkey": token!, "member_id": member_id!] as [String : Any]
           
           DispatchQueue.main.async{
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
           }
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.likesData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath) as! LikeTableViewCell
        if(self.likesData[indexPath.row].favorite == "1"){
            let url = URL(string: self.likesData[indexPath.row].url)
            
            cell.prototypeImage.downloadImage(from: url!)
            
            cell.prototypeLabel.text = self.likesData[indexPath.row].title
            
            cell.dateAndTimePostedLabel.text = self.likesData[indexPath.row].age
            
            cell.likeButton.setImage(UIImage(named: "Liked.png"), for: .normal)
            cell.likeButton.setTitle("Liked", for: .normal)
            
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
        likeTableView.reloadData()
        print("Reload")
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LikeViewController")
//
//        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
}
