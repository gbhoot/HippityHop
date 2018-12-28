//
//  RoundedButton.swift
//  HippityHop
//
//  Created by Gurpal Bhoot on 11/2/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()

        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    // Functions
    func customizeView() {
        backgroundColor =  #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        layer.cornerRadius = 5
    }

}
