//
//  SettingsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/6/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //let dummyData = DummyData()
    //var tags: [String] = []
    var settingsModel: [SettingModel] = []
    var selectedTagsModel: [SelectedTags] = []
    //private var selectedTag: [String: String] = [:]
    var selectedTagsArray: [String] = []
    
    
    @IBOutlet weak var subscribeBtn: UIButton!
    private let tagName: [String] = ["TeamChamps", "PHP", "Newsroom", "Mobile", "DotNet", "Runners", "Paddlers", "SQA", "Classifieds", "Customer Travel"]
    private var tagValue: [Bool] = [false,false,false,false,false,false,false,false,false,false]
    
    
    //var switchesOn:
    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
    
    var indxRow = 0
    var indexpathTable = IndexPath(row: 0, section: 0)
    
    private var storyID: String = ""
    private var json: JSON = []
    private var JSONresults: JSON = []
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.getSelectedTagsRequest()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.getSelectedTag()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getSelectedTagsRequest()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.getSelectedTag()
//            self.getCheckedTag()
//        }
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tagName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTableViewCell
        
        cell.tagLabelBtn.setImage(UIImage(named: self.tagName[indexPath.row] + ".png"), for: UIControl.State.normal)
        cell.tagSwitch.tag = indexPath.row
        
        cell.tagLabelBtn.setTitle(self.tagName[indexPath.row], for: .normal)

        
        
        cell.tagSwitch.isOn = self.tagValue[indexPath.row]
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)

        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LikeViewController")
//
//        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    func getSelectedTagsRequest(){
        
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getselectedtags.json") else { return }
        let params = ["APIkey": self.token ?? "", "member_id": self.member_id ?? ""] as [String : Any]
        activityIndicator("Please wait...")
        view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
             //check if the result has a value
                if response.result.isSuccess {
                    self.settingsModel.removeAll()
                    if let JSONResponse = response.result.value as? [String: Any]{
                        self.json = JSON(JSONResponse)
                        self.JSONresults = self.json["tags"]
                        self.JSONresults.array?.forEach({ (tags) in
                            //print("getSelectedTags \(self.json)")
                            let tags = SettingModel(name: tags["name"].stringValue, image: tags["image"].stringValue)
                            
                            self.settingsModel.append(tags)
                            //print("tags:\(tags)")
                            
                        })
                        self.settingsTableView.reloadData()
                        
                       //print("no of array: \(self.tagsData.count) results: \(self.tagsData[0].name)")
                    }
                }else{
                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
                }
                self.getSelectedTag()
                self.getCheckedTag()
            }

            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
        }


    }
    
    
//    func initialStateOfSwitches(){
//        getSelectedTagsRequest()
//
//        getSelectedTag()
//    }
    

// remove comments
    func getSelectedTag(){
        self.selectedTagsArray.removeAll()
        print(self.tagName.count)
        if( (self.tagName.count - 1) > 0 && (self.settingsModel.count - 1 ) > 0){
            for tag in 0...self.tagName.count - 1{
                for l in 0...self.settingsModel.count - 1{
                        if(self.tagName[tag] == self.settingsModel[l].name){
                            self.tagValue[tag] = true
                            self.selectedTagsArray.append(self.tagName[tag])
                            break
                        }else{
                            self.tagValue[tag] = false
                        }
                    }
            }
        }
    }
    
    func getCheckedTag(){
        self.selectedTagsArray.removeAll()
        for i in 0...self.tagName.count - 1{
            if(self.tagValue[i] == true){
                self.selectedTagsArray.append(self.tagName[i])
                print(self.tagName[i])
            }else{
                print(self.tagValue[i])
            }
        }
    }

    func addToSelectedTags(){
        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/addtoselectedtags.json") else { return}
        let tags = self.selectedTagsArray.joined(separator: ",")
        let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "tags": tags ] as [String : Any]
            Alamofire.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
             //check if the result has a value
                if response.result.isSuccess {
                    if let JSONResponse = response.result.value as? [String: Any]{
                        self.json = JSON(JSONResponse)
                        self.JSONresults = self.json["tags"]
                        self.JSONresults.array?.forEach({ (tags) in

                            let tags = SelectedTags(result: tags["result"].stringValue)

                            self.selectedTagsModel.append(tags)
                        })
                    }
                }else{
                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
                }

            }

    }
    
    
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        self.getSelectedTagsRequest()
        self.getCheckedTag()
        self.addToSelectedTags()
        
        print("SelectedTagsArray \(self.selectedTagsArray.count)")
        if(self.selectedTagsArray.count != 0){
            activityIndicator("Loading...")
            self.view.isUserInteractionEnabled = false
            self.subscribeBtn.isUserInteractionEnabled = false
            let image = UIImage(named: "subscribeTapped.png")
            self.subscribeBtn.setImage(image, for: .normal)
            print("Dispatch")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.getSelectedTagsRequest()
                self.getCheckedTag()
                print(self.selectedTagsArray)
                self.addToSelectedTags()
                print("asd \(self.selectedTagsArray.count)")
                let image2 = UIImage(named: "subscribe.png")
                self.subscribeBtn.setImage(image2, for: .normal)
                    
                self.view.isUserInteractionEnabled = true
                self.subscribeBtn.isUserInteractionEnabled = true
                self.stopActivityIndicator()
            }
        }else{
            print("insert atleast one")
            let alert = UIAlertController(title: "Error", message: "Choose atleast one to subscribe", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }

    }
    @IBAction func switchAction(_ sender: UISwitch) {
        
        if self.tagValue[sender.tag] == false {
            
            tagValue[sender.tag] = true
            print("switches \(tagValue[sender.tag])")
        }
        else {
            tagValue[sender.tag] = false
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
