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
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var homeTableView: UITableView!
    var storiesData: [StoryModel] = []

    let dummyData = DummyData()
    var token: JSON = []
    var member_id: JSON = []
    
    
    
    var json: JSON = []
    var JSONresults: JSON = []
    var isSuccess: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("token: \(token)")
        fetchUsersData()
    }
    
    
    func fetchUsersData(){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getstories.json") else { return }
        let params = ["APIkey": token, "member_id": member_id] as [String : Any]
        
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
                            print("Story:\(story)")
                        })
                        self.homeTableView.reloadData()
                        
                        
                        print("no of array: \(self.storiesData.count) results: \(self.storiesData[0].title)")
                    }
                }else{
                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
                }

                
            }
        }
    }
//
//    func AddToFavorites(){
//        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/addtofavorites.json") else { return }
//        let params = ["APIkey": token, "member_id": member_id, "story": ] as [String : Any]
//
//        DispatchQueue.main.async{
//            AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
//             //check if the result has a value
//                if response.result.isSuccess {
//                    if let JSONResponse = response.result.value as? [String: Any]{
//                        self.json = JSON(JSONResponse)
//                        self.JSONresults = self.json["results"]
//                        self.JSONresults.array?.forEach({ (story) in
//                            let story = StoryModel(title: story["Story"]["title"].stringValue, favorite: story["Story"]["favorite"].stringValue, acknowledged: story["Story"]["acknowledged"].stringValue, age: story["Story"]["age"].stringValue)
//                            self.storiesData.append(story)
//                            print("Story:\(story)")
//                        })
//                        self.homeTableView.reloadData()
//
//
//                        print("no of array: \(self.storiesData.count) results: \(self.storiesData[0].title)")
//                    }
//                }else{
//                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
//                }
//
//
//            }
//        }
//    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tableView: \(self.storiesData[0].title)")
        
        return self.storiesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        print("Title: \(self.storiesData[indexPath.row].title) favorite: \(self.storiesData[indexPath.row].favorite) acknowledge: \(self.storiesData[indexPath.row].acknowledged) create: \(self.storiesData[indexPath.row].age) image url: \(self.storiesData[indexPath.row].story_id) ")
        let url = URL(string: self.storiesData[indexPath.row].url)
        cell.myImage.downloadImage(from: url!)
        
        cell.homeLabel.text = self.storiesData[indexPath.row].title
        
        cell.dateTimePostedLabel.text = self.storiesData[indexPath.row].age
        
        cell.likeButton.tag = indexPath.row
        if(self.storiesData[indexPath.row].favorite == "0"){
            cell.likeButton.setImage(UIImage(named: "Like.png"), for: .normal)
            cell.likeButton.setTitle("Like", for: .normal)
            cell.likeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "Liked.png"), for: .normal)
            cell.likeButton.setTitle("Liked", for: .normal)
            cell.likeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        
        cell.acknowledgeButton.tag = indexPath.row
        
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
        print(sender.tag)
        if ( self.storiesData[sender.tag].favorite == "0") {
            self.storiesData[sender.tag].favorite = "1"
        }else{
            self.storiesData[sender.tag].favorite = "0"
        }
        homeTableView.reloadData()
        
    }
    
    @IBAction func handleAcknowledge(_ sender: UIButton) {
        if(self.storiesData[sender.tag].acknowledged == "0"){
            self.storiesData[sender.tag].acknowledged = "1"
        }
        homeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        
        let vc = storyboard?.instantiateViewController(withIdentifier: "fullDetailsOfNewsViewController")
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "homeToPreviewSegue",
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
