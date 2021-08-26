//
//  TextFiled.swift
//  SwiftPractice
//
//  Created by Nick on 21/05/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import Foundation
import UIKit


class TextFiled: UITextField
{
    
    @IBInspectable var DataType: NSString = ""
    @IBInspectable var MaxValue: NSInteger = 500
    var completionHandlerleft: ((_ sender: UIButton) -> Void)?

    @IBInspectable open var disableFloatingLabel : Bool = false

    var leadingSpaceLine = CGFloat()
     var trailingSpaceLine = CGFloat()
     var heightBottomLine = CGFloat()
    
    @IBAction func KeyBoardStroke(sender: AnyObject) {
        var txt: UITextField!
        
        txt = sender as! UITextField
        
        if (txt.text?.count)!>MaxValue {
            var str:NSString
            str = txt.text! as NSString
            
            str = str.substring(to: MaxValue) as NSString
            txt.text = str as String
            
        }
        if DataType == "Numeric"{
            
            let inverseSet = NSCharacterSet(charactersIn: "0123456789").inverted
            let components = txt.text?.components(separatedBy: inverseSet)
            let filtered = components?.joined(separator: "")
            return txt.text = filtered
            
        } else if DataType == "Numeric+Punctuation" {
            
            let inverseSet = NSCharacterSet(charactersIn: "0123456789 +").inverted
            let components = txt.text?.components(separatedBy: inverseSet)
            let filtered = components?.joined(separator: "")
            return txt.text = filtered
            
        } else if DataType == "Character" {
            
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ").inverted
            let components = txt.text?.components(separatedBy: inverseSet)
            let filtered = components?.joined(separator: "")
            return txt.text = filtered
            
        } else if DataType == "Numeric+Character" {
            
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ").inverted
            let components = txt.text?.components(separatedBy: inverseSet)
            let filtered = components?.joined(separator: "")
            return txt.text = filtered
            
        } else if DataType == "Character+Punctuation" {
            
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ<>?:}{+|_)(*&^%$#@!~,./'=-0;").inverted
            let components = txt.text?.components(separatedBy: inverseSet)
            let filtered = components?.joined(separator: "")
            return txt.text = filtered
            
        } else if DataType == "Email" {
            
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@_").inverted
            let components = txt.text?.components(separatedBy: inverseSet)
            let filtered = components?.joined(separator: "")
            return txt.text = filtered
            
        } else  if DataType == "Numericwithoutdecimal"{
            
            let inverseSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            let components = txt.text?.components(separatedBy: inverseSet)
            let filtered = components?.joined(separator: "")
            return txt.text = filtered
            
        }
        
    }
    
    
    func setLeftViewWith(_ image: UIImage?, withText text: String?, lineColor: UIColor?) {
        
        var willWidth: CGFloat = frame.size.height + 10
        if (text != nil) && !(text == "") {
            willWidth = willWidth + frame.size.height
        }
        
        let viewMain = UIView(frame: CGRect(x: 0, y: 0, width: willWidth, height: frame.size.height))
        
        let imgView = UIImageView()
        imgView.image = image
        imgView.contentMode = .center
        imgView.sizeToFit()
        viewMain.addSubview(imgView)
        imgView.frame = CGRect(x: 0, y: 5, width: viewMain.frame.size.height, height: viewMain.frame.size.height - 10)
        let lineLable: UILabel?
        if (lineColor != nil) {
            lineLable = UILabel(frame: CGRect(x: viewMain.frame.size.height, y: 2.5, width: 1, height: frame.size.height - 5))
            lineLable!.text = ""
            lineLable!.backgroundColor = lineColor
            viewMain.addSubview(lineLable!)
        } else {
            lineLable = UILabel(frame: CGRect(x: viewMain.frame.size.height, y: 2.5, width: 0, height: 0))
        }
        if (text != nil && !(text == "")) {

            let lblCountryCode2 = UILabel(frame: CGRect(x: viewMain.frame.size.height + 5, y: 0, width: frame.size.height, height: frame.size.height))
            lblCountryCode2.text = text
            lblCountryCode2.textColor = UIColor.lightGray
            lblCountryCode2.textAlignment = .center
            lblCountryCode2.font = Utility.SetRagular(Utility.TextField_Font_size())
            viewMain.addSubview(lblCountryCode2)
        }
        
        leftView = viewMain
        self.leftViewMode = .always
        self.rightViewMode = .never
    }
    
    func setLeftViewWithImageName(imageToSet : UIImage) {
        let viewMain = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: self.frame.size.height))
        let imgView = UIImageView(image: imageToSet)
        imgView.sizeToFit()
        viewMain.addSubview(imgView)
        imgView.center = CGPoint(x: viewMain.center.x  , y: viewMain.center.y)
        self.leftView = viewMain
        self.leftViewMode = .always
        self.rightViewMode = .never
    }
    
    
    func rightViewWithImageName(imageToSet : UIImage)
    {
        let viewMain = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.size.height))
        self.rightView = viewMain
        self.rightViewMode = .always
        let imgView = UIImageView(image: imageToSet)
        imgView.sizeToFit()
        viewMain.addSubview(imgView)
        imgView.center = CGPoint(x: viewMain.center.x - 6 , y: viewMain.center.y)
        
    }
    
        func setLeftPaddingPoints(_ Left:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    
        func setRightPaddingPoints(_ right:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
  
     func addRightViewIcon (_ image:UIImage){
        
        self.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 13, height: 6))
        imageView.image = image
        self.rightView = imageView
        
    }
    
    
     func addPaddingRightIcon(_ image: UIImage, padding: CGFloat) {
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.rightView = imageView
        self.rightView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        self.rightViewMode = UITextField.ViewMode.always
    }
    

    
   func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
