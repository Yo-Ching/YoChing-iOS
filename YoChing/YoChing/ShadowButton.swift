//
//  ShadowButton.swift
//  YoChing
//
//  Created by SirWellington on 12/13/15.
//  Copyright © 2016 RedRoma Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ShadowButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func prepareForInterfaceBuilder() {
        updateView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    
    @IBInspectable var borderThickness: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSizeMake(3, 0) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0.4 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 2.0 {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        
        //Create the border
        layer.borderWidth = self.borderThickness
        layer.borderColor = self.borderColor.CGColor
        
        //Create the shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.CGColor
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
}
