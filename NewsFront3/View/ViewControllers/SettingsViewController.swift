////
////  SettingsViewController.swift
////  NewsFront3
////
////  Created by Reyvie Bautista on 11/6/19.
////  Copyright © 2019 ReyvieB. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import Alamofire
//class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
//    let dummyData = DummyData()
//    //var tagss: [String] = ["TeamChamps", "PHP", "Newsroom", "Mobile", "DotNet", "Runners", "Paddlers", "SQA", "Classifieds", "Custom Travel" ]
//    var settingsModel: [SettingModel] = []
//    var selectedTagsModel: [SelectedTags] = []
//    var selectedTag: [String: String] = [:]
//    var selectedTagsArray: [String] = []
//    
//    let token: String? = UserDefaults.standard.string(forKey:"token") ?? ""
//    let member_id: String? = UserDefaults.standard.string(forKey:"member_id") ?? ""
//    
//    
//    var tagsSelected: [String] = []
//    
//    
//    var indxRow = 0
//    var indexpathTable = IndexPath(row: 0, section: 0)
//    
//    private var storyID: String = ""
//    private var json: JSON = []
//    private var JSONresults: JSON = []
//    
//    @IBOutlet weak var settingsTableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//
//        
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//
//        
//    }
//    
//    
//    
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dummyData.tagName.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTableViewCell
//        
//        cell.tagLabelBtn.setImage(UIImage(named: dummyData.tagName[indexPath.row] + ".png"), for: UIControl.State.normal)
//        cell.tagSwitch.tag = indexPath.row
//        
//        cell.tagLabelBtn.setTitle(dummyData.tagName[indexPath.row], for: .normal)
//        
//        cell.tagSwitch.isOn = dummyData.statusSwitch[indexPath.row]
//
//        if(dummyData.statusSwitch[indexPath.row] == true){
//            self.selectedTag[dummyData.tagName[indexPath.row]] = "1"
//        }else{
//            self.selectedTag[dummyData.tagName[indexPath.row]] = "0"
//        }
//        
//        
//        return (cell)
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//         tableView.deselectRow(at: indexPath, animated: true)
//
//        
////        let vc = storyboard?.instantiateViewController(withIdentifier: "LikeViewController")
////
////        self.navigationController?.pushViewController(vc!, animated: true)
//        
//    }
//    
//
//    func getSelectedTagsRequest(){
//        self.settingsModel.removeAll()
//        self.tagsSelected.removeAll()
//        guard let urlToExecute = URL(string: "http://newsfront.cloudstaff.com/apisv2/getselectedtags.json") else { return }
//        let params = ["APIkey": self.token ?? "", "member_id": self.member_id ?? ""] as [String : Any]
//            AF.request(urlToExecute, method: .post, parameters: params).responseJSON{ (response) in
//             //check if the result has a value
//                if response.result.isSuccess {
//                    if let JSONResponse = response.result.value as? [String: Any]{
//                        self.json = JSON(JSONResponse)
//                        self.JSONresults = self.json["tags"]
//                        self.JSONresults.array?.forEach({ (tags) in
//                            let tags = SettingModel(name: tags["name"].stringValue, image: tags["image"].stringValue)
//
//                            self.settingsModel.append(tags)
//                            
//                        })
//                        
//                        for x in 0...self.settingsModel.count - 1 {
//                            self.tagsSelected.append(self.settingsModel[x].name)
//                        }
//                        
//                        print("http: \(self.tagsSelected)")
//                        
//                        self.settingsTableView.reloadData()
//                    }
//                }else{
//                    print("Alamofire Error: \(response.result.error!.localizedDescription)")
//                }
//
//            }
//        print("http2: \(self.tagsSelected)")
//
//    }
//    
//    
//    @IBAction func subscribeAction(_ sender: UIButton) {
//        self.getSelectedTagsRequest()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
//            print("viewDidLoad: \(self.tagsSelected)")
//        }
//        print("viewDidLoad2: \(self.tagsSelected)")
//    }
//    
//    @IBAction func switchAction(_ sender: UISwitch) {
//
//    }
//    
//    
//    
//
//
//}
