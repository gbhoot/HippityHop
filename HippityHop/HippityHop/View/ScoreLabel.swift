//
//  ScoreLabel.swift
//  HippityHop
//
//  Created by Gurpal Bhoot on 11/2/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit

@IBDesignable
class ScoreLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }

    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        layer.cornerRadius = 10
        backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.borderColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        layer.borderWidth = 3.0
        layer.masksToBounds = true
      
    }

}
