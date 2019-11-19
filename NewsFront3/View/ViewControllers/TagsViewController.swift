//
//  TagsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/7/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //let dummyData = DummyData()
    @IBOutlet weak var TagsCollectionView: UICollectionView!
    private var tagsData: [TagModel] = []
    private var json: JSON!
    
    private var JSONresults: JSON!
    //UserDefaults
    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.tagsData.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagsCollectionViewCell
        let cellIndex = indexPath.item
        let url = URL(string: tagsData[indexPath.row].image)
        cell.tagImage.downloadImage(from: url!)
        cell.tagIcon.image = UIImage(named: tagsData[cellIndex].name + ".png")
        cell.tagLabel.text = tagsData[indexPath.row].name
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 0.0
        cell.layer.borderWidth = 0.5
        
        
        return (cell)
    }
               
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTags()
        self.TagsCollectionView.reloadData()

        // Do any additional setup after loading the view.
    }

    
    func fetchTags(){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getselectedtags.json") else { return }
        let params = ["APIkey": self.token ?? "", "member_id": self.member_id ?? ""] as [String : Any]
        
        DispatchQueue.main.async{
            AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
             //check if the result has a value
                if response.result.isSuccess {
                    if let JSONResponse = response.result.value as? [String: Any]{
                        self.json = JSON(JSONResponse)
                        self.JSONresults = self.json["tags"]
                        self.JSONresults.array?.forEach({ (tags) in
                           // print("getSelectedTags \(self.json!)")
                            let tags = TagModel(new: tags["new"].stringValue, name: tags["name"].stringValue, image: tags["image"].stringValue)

                            self.tagsData.append(tags)
                            //print("tags:\(tags)")
                        })
                        self.TagsCollectionView.reloadData()


                       //print("no of array: \(self.tagsData.count) results: \(self.tagsData[0].name)")
                    }
                }else{
                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
                }


            }
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
    
    
    


    
    

}
