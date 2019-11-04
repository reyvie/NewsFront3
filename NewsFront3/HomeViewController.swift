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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (images.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        cell.myImage.image = UIImage(named: images[indexPath.row] + ".jpg")
        
        cell.homeLabel.text = images[indexPath.row]
        
        cell.dateTimePostedLabel.text = datePosted[indexPath.row]
        
        cell.likeButton.setImage(UIImage(named: likeStatus[indexPath.row] + ".png"), for: .normal)
        cell.likeButton.setTitle(likeStatus[indexPath.row], for: .normal)
        
        //cell.likeButton.setTitleColor(<#T##color: UIColor?##UIColor?#>, for: <#T##UIControl.State#>)
        
        return (cell)
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
