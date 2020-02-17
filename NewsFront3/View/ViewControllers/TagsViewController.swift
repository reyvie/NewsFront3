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

class TagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let dummyData = DummyData()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.45, height: height * 0.30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagsCollectionViewCell
        let cellIndex = indexPath.item
//        let url = URL(string: tagsData[indexPath.row].image)
//        cell.tagImage.downloadImage(from: url!)
        cell.tagImage.image = UIImage(named: dummyData.tagName[cellIndex] + " Image.png" )
        cell.tagIcon.image = UIImage(named: tagsData[cellIndex].name + ".png")
        cell.tagLabel.text = tagsData[indexPath.row].name
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 0.0
        cell.layer.borderWidth = 0.5
        
        
        return (cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.async{
            
            let tagsVC = self.storyboard?.instantiateViewController(withIdentifier: "TagsDetailsViewController") as? TagsDetailsViewController
            tagsVC?.name = self.tagsData[indexPath.row].name
            
            //vc?.indexRow = indexPath.row
            self.navigationController?.pushViewController(tagsVC!, animated: true)
            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchTags()
    }
    
    func fetchTags(){
        
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getselectedtags.json") else { return }
        let params = ["APIkey": self.token ?? "", "member_id": self.member_id ?? ""] as [String : Any]
        
        activityIndicator("Loading...")
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
             //check if the result has a value
                if response.result.isSuccess {
                    self.tagsData.removeAll()
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
            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
        }

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

    
    

}
