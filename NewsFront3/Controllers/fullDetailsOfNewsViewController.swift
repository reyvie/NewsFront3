//
//  fullDetailsOfNewsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/4/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class fullDetailsOfNewsViewController: UIViewController {

    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var acknowledgeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textContent.sizeToFit()
//        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)

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
