//
//  TagsDetailsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/26/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
class TagsDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tagsTableView: UITableView!
    var name: String = ""
    var storiesData: [StoryModel] = []
    let token: String = UserDefaults.standard.string(forKey:"token")!
    let member_id: String = UserDefaults.standard.string(forKey:"member_id")!
    var indxRow = 0
    var indexpathTable = IndexPath(row: 0, section: 0)
    
    private var storyID: String = ""
    private var json: JSON = []
    private var JSONresults: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        fetchStoriesOfTag()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storiesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagsTableViewCell

        let url = URL(string: self.storiesData[indexPath.row].url)
        //let urlOptional = URL(string: "https://visualsound.com/products/smart-inventory-clearance/unavailable-image/")
        //cell.myImage.downloadImage(from: url!)
        cell.myImage.sd_setImage(with: url!, placeholderImage: UIImage(contentsOfFile:"defaultImage.png"))
        cell.tagsLabel.text = self.storiesData[indexPath.row].title
        
        cell.ageLbl.text = self.storiesData[indexPath.row].age
        
        cell.likeBtn.tag = indexPath.row
        cell.acknowledgeBtn.tag = indexPath.row

    
    
        if(self.storiesData[indexPath.row].favorite == "0"){
            cell.likeBtn.setImage(UIImage(named: "Like.png"), for: .normal)
            cell.likeBtn.setTitle("Like", for: .normal)
            cell.likeBtn.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.likeBtn.setImage(UIImage(named: "Liked.png"), for: .normal)
            cell.likeBtn.setTitle("Liked", for: .normal)
            cell.likeBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        if(self.storiesData[indexPath.row].acknowledged == "0"){
            cell.acknowledgeBtn.setImage(UIImage(named: "Acknowledge.png"), for: .normal)
            cell.acknowledgeBtn.setTitle("Acknowledge", for: .normal)
            cell.acknowledgeBtn.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.acknowledgeBtn.setImage(UIImage(named: "Acknowledged.png"), for: .normal)
            cell.acknowledgeBtn.setTitle("Acknowledged", for: .normal)
            cell.acknowledgeBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        return (cell)
    }

    
    func fetchStoriesOfTag(){
        
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getstoriesoftag.json") else { return }
        let params = ["APIkey": token, "member_id": member_id, "name": name] as [String : Any]
        
        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
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
                self.tagsTableView.reloadData()
            }
            self.view.isUserInteractionEnabled = true
            self.stopActivityIndicator()
        }
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
}
