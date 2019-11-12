//
//  HomeViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/4/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var homeTableView: UITableView!
    

    let dummyData = DummyData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dummyData.images.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        cell.myImage.image = UIImage(named: dummyData.images[indexPath.row] + ".jpg")
        
        cell.homeLabel.text = dummyData.images[indexPath.row]
        
        cell.dateTimePostedLabel.text = dummyData.datePosted[indexPath.row]
        
        cell.likeButton.tag = indexPath.row
   
        cell.likeButton.setImage(UIImage(named: dummyData.likeStatus[indexPath.row] + ".png"), for: .normal)
        cell.likeButton.setTitle(dummyData.likeStatus[indexPath.row], for: .normal)
        cell.acknowledgeButton.tag = indexPath.row
        
        cell.acknowledgeButton.setImage(UIImage(named: dummyData.acknowledgeStatus[indexPath.row] + ".png"), for: .normal)
        cell.acknowledgeButton.setTitle(dummyData.acknowledgeStatus[indexPath.row], for: .normal)

        if(dummyData.likeStatus[indexPath.row] == "Like"){
            cell.likeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.likeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        if(dummyData.acknowledgeStatus[indexPath.row] == "Acknowledge"){
            cell.acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.acknowledgeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        
        return (cell)
    }
    
    @IBAction func handleLikes(_ sender: UIButton) {
        print(sender.tag)
        if ( dummyData.likeStatus[sender.tag] == "Like") {
            dummyData.likeStatus[sender.tag] = "Liked"
        }else{
            dummyData.likeStatus[sender.tag] = "Like"
        }
        homeTableView.reloadData()
        
    }
    
    @IBAction func handleAcknowledge(_ sender: UIButton) {
        if(dummyData.acknowledgeStatus[sender.tag] == "Acknowledge"){
            dummyData.acknowledgeStatus[sender.tag] = "Acknowledged"
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
