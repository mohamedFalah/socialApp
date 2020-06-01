//
//  FancyView.swift
//  socialApp
//
//  Created by Mohammed Alshulah on 02/06/2020.
//  Copyright © 2020 Mohammed Alshulah. All rights reserved.
//

import UIKit

class FancyView : UIView {
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    
}
