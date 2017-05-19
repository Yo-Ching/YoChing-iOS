//
//  ShadowButton.swift
//  YoChing
//
//  Created by SirWellington on 12/13/15.
//  Copyright © 2016 Yo Ching. All rights reserved.
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

    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            updateView()
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 0) {
        didSet {
            updateView()
        }
    }

    @IBInspectable var shadowColor: UIColor = UIColor.darkGray {
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

    fileprivate func updateView() {

        //Create the border
        layer.borderWidth = self.borderThickness
        layer.borderColor = self.borderColor.cgColor

        //Create the shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
}
