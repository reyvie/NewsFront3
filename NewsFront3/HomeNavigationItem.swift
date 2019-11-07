//
//  HomeNavigationItem.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/7/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class HomeNavigationItem: UINavigationItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.font : UIFont(name: "Roboto-Medium", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController.navigationBar.titleTextAttributes = attributes
        // Do any additional setup after loading the view.
    }
    
    
}
