//
//  HomeTableViewCell.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/4/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var homeLabel: UILabel!
    
    @IBOutlet weak var myImage: UIImageView!

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var acknowledgeButton: UIButton!
    @IBOutlet weak var dateTimePostedLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
