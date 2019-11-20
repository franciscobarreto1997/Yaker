//
//  PostTableViewCell.swift
//  Yaker
//
//  Created by Francisco Barreto on 14/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var postTimeStampLabel: UILabel!
    @IBOutlet weak var arrowUpButton: UIButton!
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var arrowDownButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
