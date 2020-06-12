//
//  ImageViewCustomization.swift
//  socialApp
//
//  Created by Mohammed Alshulah on 12/06/2020.
//  Copyright © 2020 Mohammed Alshulah. All rights reserved.
//

import UIKit

class ImageViewCustomization: UIImageView {

    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
           layer.borderWidth = 1.0
           layer.cornerRadius = 5.0
       }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
