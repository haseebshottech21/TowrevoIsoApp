//
//  DesignableViews.swift
//  WonderWomen
//
//  Created by Jayesh Dabhi on 28/08/19.
//  Copyright © 2019 Vrinsoft. All rights reserved.
//

import UIKit


@IBDesignable
class CustomView: UIView {
   
    private var theShadowLayer: CAShapeLayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    @IBInspectable var border_Color: UIColor = .black {
        didSet {
            self.layer.borderColor = self.border_Color.cgColor
            updateView()
        }
    }
    
    @IBInspectable var border_Width: CGFloat = 0.00 {
        didSet {
            self.layer.borderWidth = self.border_Width
            updateView()
        }
    }
    
    @IBInspectable var corner_Radius: CGFloat = 0.00 {
        didSet {
            self.layer.cornerRadius = self.corner_Radius
            updateView()
        }
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            self.layer.cornerRadius = self.frame.size.height / 2.0
            updateView()
        }
    }
    
    @IBInspectable var shadow_Radius: CGFloat = 0.00 {
        didSet {
            self.layer.shadowRadius = self.shadow_Radius
            updateView()
        }
    }
    
    @IBInspectable var shadow_Opacity: CGFloat = 0.00 {
        didSet {
            self.layer.shadowOpacity = Float(self.shadow_Opacity)
            updateView()
        }
    }
    
    @IBInspectable var shadow_Offset: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = self.shadow_Offset
            updateView()
        }
    }
    
    @IBInspectable var shadow_Color: UIColor = UIColor.black {
        didSet {
            self.layer.shadowColor = self.shadow_Color.cgColor
            updateView()
        }
    }
    
    func updateView() {
        
        if self.theShadowLayer == nil {
            
            let shadowLayer = CAShapeLayer.init()
            self.theShadowLayer = shadowLayer
            
            shadowLayer.masksToBounds = false
            shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: self.corner_Radius).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            
            shadowLayer.shadowPath = shadowLayer.path
            
            shadowLayer.borderColor = self.border_Color.cgColor
            shadowLayer.borderWidth = self.border_Width
            
            shadowLayer.shadowColor = self.shadow_Color.cgColor
            shadowLayer.shadowRadius = self.shadow_Radius
            shadowLayer.shadowOpacity = Float(self.shadow_Opacity)
            shadowLayer.shadowOffset = self.shadow_Offset
            
            shadowLayer.shouldRasterize = true
            shadowLayer.rasterizationScale = UIScreen.main.scale
            
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

@IBDesignable
class CustomButton: UIButton {
    
    private var theShadowLayer: CAShapeLayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    @IBInspectable var border_Color: UIColor = .black {
        didSet {
            self.layer.borderColor = self.border_Color.cgColor
            updateView()
        }
    }
    
    @IBInspectable var border_Width: CGFloat = 0.00 {
        didSet {
            self.layer.borderWidth = self.border_Width
            updateView()
        }
    }
    
    @IBInspectable var corner_Radius: CGFloat = 0.00 {
        didSet {
            self.layer.cornerRadius = self.corner_Radius
            updateView()
        }
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            self.layer.cornerRadius = self.frame.size.height / 2.0
            updateView()
        }
    }
    
    @IBInspectable var shadow_Radius: CGFloat = 0.00 {
        didSet {
            self.layer.shadowRadius = self.shadow_Radius
            updateView()
        }
    }
    
    @IBInspectable var shadow_Opacity: CGFloat = 0.00 {
        didSet {
            self.layer.shadowOpacity = Float(self.shadow_Opacity)
            updateView()
        }
    }
    
    @IBInspectable var shadow_Offset: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = self.shadow_Offset
            updateView()
        }
    }
    
    @IBInspectable var shadow_Color: UIColor = UIColor.black {
        didSet {
            self.layer.shadowColor = self.shadow_Color.cgColor
            updateView()
        }
    }
    
    func updateView() {
        
        if self.theShadowLayer == nil {
            
            let shadowLayer = CAShapeLayer.init()
            self.theShadowLayer = shadowLayer
            
            shadowLayer.masksToBounds = false
            shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: self.corner_Radius).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            
            shadowLayer.shadowPath = shadowLayer.path
            
            shadowLayer.borderColor = self.border_Color.cgColor
            shadowLayer.borderWidth = self.border_Width
            
            shadowLayer.shadowColor = self.shadow_Color.cgColor
            shadowLayer.shadowRadius = self.shadow_Radius
            shadowLayer.shadowOpacity = Float(self.shadow_Opacity)
            shadowLayer.shadowOffset = self.shadow_Offset
            
            shadowLayer.shouldRasterize = true
            shadowLayer.rasterizationScale = UIScreen.main.scale
            
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
 
    
  
}

