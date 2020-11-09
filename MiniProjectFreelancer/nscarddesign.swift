//
//  nscarddesign.swift
//  MiniProjectFreelancer
//
//  Created by ESPRIT on 02/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
@IBDesignable
class nscarddesign: UIView {
    
    @IBInspectable var shadowWidth: Int = 0
    @IBInspectable var shadowHeight: Int = 0
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var shadowColor: UIColor = .black
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        let path = UIBezierPath(roundedRect: bounds , cornerRadius: cornerRadius)
        layer.shadowPath=path.cgPath
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
    }

}
