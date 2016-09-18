//
//  FriendTableViewCell.swift
//  PandaFit
//
//  Created by Felix Sonntag on 17/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {


    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
