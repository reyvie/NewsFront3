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
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    let dummyData = DummyData()
    //var tagss: [String] = ["TeamChamps", "PHP", "Newsroom", "Mobile", "DotNet", "Runners", "Paddlers", "SQA", "Classifieds", "Custom Travel" ]
    var settingsModel: [SettingModel] = []
    var selectedTagsModel: [SelectedTags] = []
    var selectedTag: [String: String] = [:]
    var selectedTagsArray: [String] = []
    //var switchesOn:
    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
    
    var indxRow = 0
    var indexpathTable = IndexPath(row: 0, section: 0)
    
    private var storyID: String = ""
    private var json: JSON = []
    private var JSONresults: JSON = []
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.tagName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTableViewCell
        
        cell.tagLabelBtn.setImage(UIImage(named: dummyData.tagName[indexPath.row] + ".png"), for: UIControl.State.normal)
        cell.tagSwitch.tag = indexPath.row
        
        cell.tagLabelBtn.setTitle(dummyData.tagName[indexPath.row], for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
        }
        
       //self.getSelectedTag()
        
        //self.settingsTableView.reloadData()
        
//        if(self.settingsModel[l].name){
//
//        }
        
        print("selectedTag: \(self.selectedTag.count)")
        print("settingsModel: \(self.settingsModel.count)")

//        if(self.selectedTag.count > 0 ){
//            self.getSelectedTag()
//
//        for tag in 0...self.selectedTag.count - 1{
//            for l in 0...self.settingsModel.count - 1{
//                    if(Array(self.selectedTag)[tag].key == self.settingsModel[l].name){
//                        cell.tagSwitch.isOn = true
//                        break
//                    }else{
//                        cell.tagSwitch.isOn = false
//                    }
//                }
//                print("cell key: \(Array(self.selectedTag)[tag].key) value: \(Array(self.selectedTag)[tag].value)")
//
//        }
//        }
        
        
        //
        cell.tagSwitch.isOn = dummyData.statusSwitch[indexPath.row]

        if(dummyData.statusSwitch[indexPath.row] == true){
            self.selectedTag[dummyData.tagName[indexPath.row]] = "1"
        }else{
            self.selectedTag[dummyData.tagName[indexPath.row]] = "0"
        }
        
        
        return (cell)
    }
    
    func getSelectedTagsRequest(){
        self.settingsModel.removeAll()
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

            }
        }
        
    }
    
    
//    func initialStateOfSwitches(){
//        getSelectedTagsRequest()
//
//        getSelectedTag()
//    }
    
    
// remove comments
//    func getSelectedTag(){
//        //self.getSelectedTagsRequest()
//        print("CoUNT: \(self.settingsModel.count)")
//        print("count: \(self.selectedTag.count)")
//
//        if( (self.selectedTag.count - 1) > 0 && (self.settingsModel.count - 1 ) > 0){
//
//
//        for tag in 0...self.selectedTag.count - 1{
////            if((Array(self.selectedTag)[tag].key) == self.settingsModel[tag].name){
////
//            for l in 0...self.settingsModel.count - 1{
//                    if(Array(self.selectedTag)[tag].key == self.settingsModel[l].name){
//                        self.selectedTag[(Array(self.selectedTag)[tag].key)] = "1"
//                        self.selectedTagsArray.append((Array(self.selectedTag)[tag].key))
//                        break
//                    }else{
//                        self.selectedTag[(Array(self.selectedTag)[tag].key)] = "0"
//                    }
//
//                }
//                print("selectedTagsArray \(self.selectedTagsArray)")
//                print("key: \(Array(self.selectedTag)[tag].key) value: \(Array(self.selectedTag)[tag].value)")
////            }else{
////                print("key: \(Array(self.selectedTag)[tag].key) value: \(Array(self.selectedTag)[tag].value)")
////
////            }
//
//        }
//        }else{
//            print("less than 0")
//        }
//    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            //tableView.deselectRow(at: indexPath, animated: true)

            
    //        let vc = storyboard?.instantiateViewController(withIdentifier: "LikeViewController")
    //
    //        self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    
//remove comments
//    func addToSelectedTags(){
//        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/addtoselectedtags.json") else { return }
//        let params = ["APIkey": token ?? "", "member_id": member_id ?? "", "tags": self.selectedTagsArray ] as [String : Any]
//            AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
//             //check if the result has a value
//
//                if response.result.isSuccess {
//                    if let JSONResponse = response.result.value as? [String: Any]{
//                        self.json = JSON(JSONResponse)
//                        self.JSONresults = self.json["tags"]
//                        self.JSONresults.array?.forEach({ (tags) in
//
//                            let tags = SelectedTags(result: tags["result"].stringValue)
//
//                            self.selectedTagsModel.append(tags)
//                           // print("Story:\(story)")
//                        })
//
//                       // self.homeTableView.reloadData()
//
//
//                        //print("addtoselectedtags no of array: \(self.selectedTagsModel.count) results: \(self.selectedTagsModel[0])")
//                    }
//                }else{
//                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
//                }
//
//            }
//
//    }
    
    
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        //addToSelectedTags()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
           // self.getSelectedTagsRequest()
        }
        
        //self.getSelectedTag()
        //self.settingsTableView.reloadData()
        //print(self.selectedTag)
        //print(self.settingsModel.count)
    }
    @IBAction func switchAction(_ sender: UISwitch) {
        
//        self.selectedTagsModel[sender.tag]
//
//
//        //print(sender.tag)
//        storyID = self.storiesData[sender.tag].story_id
//
//        //print("Story ID: \(storyID)")
//        if ( self.storiesData[sender.tag].favorite == "0") {
//            self.storiesData[sender.tag].favorite = "1"
//            AddToFavorites(story_ID: storyID)
//        }else{
//            self.storiesData[sender.tag].favorite = "0"
//            RemoveFromFavorites(story_ID: storyID)
//        }
//
//        homeTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.getSelectedTagsRequest()
//        print("view \(self.selectedTag.count)")
//
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.getSelectedTag()
//        }
//        print("view \(self.selectedTag.count)")
//        self.settingsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.getSelectedTagsRequest()
//        }
//        print(self.selectedTag.count)
//        self.getSelectedTag()
        //self.getSelectedTagsRequest()
        
//        self.getSelectedTag()
//
//        print("vwa \(self.selectedTag.count)")
//        print("vwa \(self.settingsModel.count)")
        
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
