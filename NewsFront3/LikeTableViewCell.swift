//
//  LikeTableViewCell.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/5/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    //MARK: PROPERTIES
    
    @IBOutlet weak var prototypeImage: UIImageView!
    @IBOutlet weak var prototypeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var acknowledgeButton: UIButton!
    @IBOutlet weak var dateAndTimePostedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
