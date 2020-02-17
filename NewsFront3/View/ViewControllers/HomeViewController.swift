//
//  HomeViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/4/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import AlamofireImage
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTableView: UITableView!
    var storiesData: [StoryModel] = []
    let token: String = UserDefaults.standard.string(forKey:"token")!
    let member_id: String = UserDefaults.standard.string(forKey:"member_id")!
    var indxRow = 0
    var indexpathTable = IndexPath(row: 0, section: 0)
    
    private var storyID: String = ""
    private var json: JSON = []
    private var JSONresults: JSON = []
    //private var isSuccess: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       fetchUsersData()
    }

    
    func fetchUsersData(){
        
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getstories.json") else { return }
        let params = ["APIkey": token, "member_id": member_id] as [String : Any]
        
        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
             //check if the result has a value
                if response.result.isSuccess {
                    self.storiesData.removeAll()
                    if let JSONResponse = response.result.value as? [String: Any]{
                        self.json = JSON(JSONResponse)
                        self.JSONresults = self.json["results"]
                        self.JSONresults.array?.forEach({ (story) in
                            
                            let story = StoryModel(title: story["Story"]["title"].stringValue, content: story["Story"]["content"].stringValue, created: story["Story"]["created"].stringValue, age: story["Story"]["age"].stringValue, acknowledged: story["Story"]["acknowledged"].stringValue, favorite: story["Story"]["favorite"].stringValue, id: story["Images"][0]["id"].stringValue, url: story["Images"][0]["url"].stringValue, story_id: story["Images"][0]["story_id"].stringValue  )
                            
                            self.storiesData.append(story)
                        })
                        
                    }
                }else{
                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
                }
                self.homeTableView.reloadData()
            }
            self.view.isUserInteractionEnabled = true
            self.stopActivityIndicator()
       // }
    }

    func AddToFavorites(story_ID: String){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/addtofavorites.json") else { return }
        let params = ["APIkey": token, "member_id": member_id, "story": story_ID] as [String : Any]
        
        
        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
       // DispatchQueue.main.async{
            
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
            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
            
       // }
    }
    
    func AcknowledgeStory(story_ID: String){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/acknowledgestory.json") else { return }
        let params = ["APIkey": token, "member_id": member_id, "story_id": story_ID] as [String : Any]

        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
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
            }
            self.view.isUserInteractionEnabled = true
            self.stopActivityIndicator()
        //}
    }
    
    
    func RemoveFromFavorites(story_ID: String){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/removefromfavorites.json") else { return }
        let params = ["APIkey": token, "member_id": member_id, "story": story_ID] as [String : Any]
        
        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
 
            Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
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
            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
        //}
    }
    //tableViewLayout
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tableView: \(self.storiesData[0].title)")
        
        return self.storiesData.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell

        let url = URL(string: self.storiesData[indexPath.row].url)
        //cell.myImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
       // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){

        cell.myImage.image = nil
        print("out image downloaded: \(indexPath.row)")
        print(self.storiesData[indexPath.row])
        Alamofire.request(self.storiesData[indexPath.row].url).responseImage { response in
//            debugPrint(response)
//
//            print(response.request)
//            print(response.response)
//            debugPrint(response.result)
            if let image = response.result.value {
                print("image downloaded: \(indexPath.row)")
                cell.myImage.image = image
            }
        }
        
        
//            Alamofire.request(url!).response{ response in
//                print(response.response?.statusCode ?? 0)
//                if(response.response?.statusCode == 404){
//                   // cell.myImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
//
//                    cell.myImage.sd_imageIndicator = nil
//                    cell.myImage.sd_setImage(with: URL(string: "https://www.digitalcitizen.life/sites/default/files/styles/lst_small/public/featured/2016-08/photo_gallery.jpg")
//                        , placeholderImage: nil)
//
//                }else{
//                    cell.myImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                    cell.myImage.sd_setImage(with: url!, placeholderImage: nil)
//                }
//             }
        //}
        cell.homeLabel.text = self.storiesData[indexPath.row].title
        
        cell.dateTimePostedLabel.text = self.storiesData[indexPath.row].age
        
        cell.likeButton.tag = indexPath.row
        cell.acknowledgeButton.tag = indexPath.row

    
    
        if(self.storiesData[indexPath.row].favorite == "0"){
            cell.likeButton.setImage(UIImage(named: "Like.png"), for: .normal)
            cell.likeButton.setTitle("Like", for: .normal)
            cell.likeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "Liked.png"), for: .normal)
            cell.likeButton.setTitle("Liked", for: .normal)
            cell.likeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        
        
        if(self.storiesData[indexPath.row].acknowledged == "0"){
            cell.acknowledgeButton.setImage(UIImage(named: "Acknowledge.png"), for: .normal)
            cell.acknowledgeButton.setTitle("Acknowledge", for: .normal)
            cell.acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.acknowledgeButton.setImage(UIImage(named: "Acknowledged.png"), for: .normal)
            cell.acknowledgeButton.setTitle("Acknowledged", for: .normal)
            cell.acknowledgeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        return (cell)
    }
    
    @IBAction func handleLikes(_ sender: UIButton) {
        //print(sender.tag)
        storyID = self.storiesData[sender.tag].story_id
        
        //print("Story ID: \(storyID)")
        
        if ( self.storiesData[sender.tag].favorite == "0") {
            self.storiesData[sender.tag].favorite = "1"
            AddToFavorites(story_ID: storyID)
        }else{
            self.storiesData[sender.tag].favorite = "0"
            RemoveFromFavorites(story_ID: storyID)
        }

        fetchUsersData()
        
    }
    
    @IBAction func handleAcknowledge(_ sender: UIButton) {
        storyID = self.storiesData[sender.tag].story_id
        
        if(self.storiesData[sender.tag].acknowledged == "0"){
            self.storiesData[sender.tag].acknowledged = "1"
            AcknowledgeStory(story_ID: storyID)
            //print("STORYID \(storyID)")
        }
        fetchUsersData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
        //DispatchQueue.main.async{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "fullDetailsOfNewsViewController") as? fullDetailsOfNewsViewController
            vc?.titleContent = self.storiesData[indexPath.row].title
            vc?.content = self.storiesData[indexPath.row].content
            vc?.created = self.storiesData[indexPath.row].created
            vc?.age = self.storiesData[indexPath.row].age
            vc?.acknowledged = self.storiesData[indexPath.row].acknowledged
            vc?.favorite = self.storiesData[indexPath.row].favorite
            
            vc?.id = self.storiesData[indexPath.row].id
            vc?.url = self.storiesData[indexPath.row].url
            vc?.story_id = self.storiesData[indexPath.row].story_id
            
            vc?.indexRow = indexPath.row
            self.navigationController?.pushViewController(vc!, animated: true)
            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
            
        //}

        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "PushToFullDetails",
//            let nextScene = segue.destination as? ViewController,
//            let indexPath = self.tableView.indexPathForSelectedRow {
//            let selectedRow = images[indexPath.row]
//            nextScene.
//
//
//        }
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView {
   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
   }
   func downloadImage(from url: URL) {
      getData(from: url) {
         data, response, error in
         guard let data = data, error == nil else {
            return
         }
         DispatchQueue.main.async() {
            self.image = UIImage(data: data)
         }
      }
   }
}
