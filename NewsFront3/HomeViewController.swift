//
//  HomeViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/4/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let images = ["Up up in the Clouds!", "Cloudstaff - The #1 workplace in the Philippines"]
    let datePosted = ["34d 22h 59m ago", "34d 22h 59m ago"]
    let likeStatus = ["Like", "Liked"]
    let acknowledgeStatus = ["Acknowledge", "Acknowledged"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (images.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        cell.myImage.image = UIImage(named: images[indexPath.row] + ".jpg")
        
        cell.homeLabel.text = images[indexPath.row]
        
        cell.dateTimePostedLabel.text = datePosted[indexPath.row]
        
        cell.likeButton.setImage(UIImage(named: likeStatus[indexPath.row] + ".png"), for: .normal)
        cell.likeButton.setTitle(likeStatus[indexPath.row], for: .normal)
        cell.acknowledgeButton.setImage(UIImage(named: acknowledgeStatus[indexPath.row] + ".png"), for: .normal)
        cell.acknowledgeButton.setTitle(acknowledgeStatus[indexPath.row], for: .normal)
        
        if(likeStatus[indexPath.row] == "Like"){
            cell.likeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.likeButton.setTitleColor(UIColor.blue, for: .normal)
        }
        if(acknowledgeStatus[indexPath.row] == "Acknowledge"){
            cell.acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            cell.acknowledgeButton.setTitleColor(UIColor.blue, for: .normal)
        }
        
        
        return (cell)
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
