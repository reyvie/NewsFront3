//
//  LikeViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/5/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {

    @IBOutlet weak var likeTableView: UITableView!
    
    let dummyData = DummyData()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var likedTotal = 0;
//        for likes in likeStatus{
//            if(likes == "Liked"){
//                likedTotal += 1
//            }
//
//        }
//        print(likedTotal)
        return dummyData.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath) as! LikeTableViewCell
        if(dummyData.likeStatus[indexPath.row] == "Liked"){
            cell.prototypeImage.image = UIImage(named: dummyData.images[indexPath.row] + ".jpg")
            cell.prototypeLabel.text = dummyData.images[indexPath.row]
            
            cell.dateAndTimePostedLabel.text = dummyData.datePosted[indexPath.row]
            
            cell.likeButton.setImage(UIImage(named: dummyData.likeStatus[indexPath.row] + ".png"), for: .normal)
            cell.likeButton.setTitle(dummyData.likeStatus[indexPath.row], for: .normal)
            cell.acknowledgeButton.setImage(UIImage(named: dummyData.acknowledgeStatus[indexPath.row] + ".png"), for: .normal)
            cell.acknowledgeButton.setTitle(dummyData.acknowledgeStatus[indexPath.row], for: .normal)
            
            if(dummyData.acknowledgeStatus[indexPath.row] == "Acknowledge"){
                cell.acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
            }else{
                cell.acknowledgeButton.setTitleColor(UIColor.systemBlue, for: .normal)
            }
        } else{
//            cell.isHidden = true
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        likeTableView.reloadData()
        print("Reload")
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LikeViewController")
//
//        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeTableView.reloadData()
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
