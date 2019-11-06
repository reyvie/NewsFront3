//
//  SettingsTableViewCell.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/6/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var tagLabelBtn: UIButton!
    @IBOutlet weak var tagSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
