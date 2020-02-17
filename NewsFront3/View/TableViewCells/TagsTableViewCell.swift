//
//  TagsTableViewCell.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/26/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var acknowledgeBtn: UIButton!
    
    @IBOutlet weak var ageLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
