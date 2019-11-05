//
//  LikeViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/5/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {
    let images = ["Up up in the Clouds!", "Cloudstaff - The #1 workplace in the Philippines", "Cloudstaff - The #1 workplace in the Philippines"]
    let datePosted = ["1", "2", "3"]
    let likeStatus = ["Liked", "Like", "Liked"]
    let acknowledgeStatus = ["Acknowledge", "Acknowledged", "Acknowledge"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var likedTotal = 0;
//        for likes in likeStatus{
//            if(likes == "Liked"){
//                likedTotal += 1
//            }
//
//        }
//        print(likedTotal)
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath) as! LikeTableViewCell
        if(likeStatus[indexPath.row] == "Liked"){
            cell.prototypeImage.image = UIImage(named: images[indexPath.row] + ".jpg")
            cell.prototypeLabel.text = images[indexPath.row]
            
            cell.dateAndTimePostedLabel.text = datePosted[indexPath.row]
            
            cell.likeButton.setImage(UIImage(named: likeStatus[indexPath.row] + ".png"), for: .normal)
            cell.likeButton.setTitle(likeStatus[indexPath.row], for: .normal)
            cell.acknowledgeButton.setImage(UIImage(named: acknowledgeStatus[indexPath.row] + ".png"), for: .normal)
            cell.acknowledgeButton.setTitle(acknowledgeStatus[indexPath.row], for: .normal)
            
            if(acknowledgeStatus[indexPath.row] == "Acknowledge"){
                cell.acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
            }else{
                cell.acknowledgeButton.setTitleColor(UIColor.blue, for: .normal)
            }
            return (cell)
        } else{
//            cell.isHidden = true
            return cell
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
