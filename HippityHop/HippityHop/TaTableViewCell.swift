//
//  TaTableViewCell.swift
//  HippityHop
//
//  Created by Kim Do on 11/1/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit

class TaTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
