//
//  CustomSegmentedControl.swift
//  Roommate
//
//  Created by ThongVM on 9/23/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegmentedControl: UISegmentedControl {
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
  

}
