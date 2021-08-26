//
//  CarouselView.swift
//  Monuments
//
//  Created by jayesh.d on 31/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit

class CarouselView: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var btnTrip: UIButton!

    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var cnstrntBtnTripWidth: NSLayoutConstraint!
    @IBOutlet weak var viewBgRating: UIView!
    @IBOutlet weak var lblParkDes: UILabel!
    @IBOutlet weak var imgCAr: UIImageView!


    var parentVc : UIViewController?
    
    func setUI() {

        
        lblTitle.setFont(font: .SemiBold, size: 12)
        lblTitle.textColor = UIColor.black
        
        lblAddress.setFont(font: .Regular, size: 11)
        lblAddress.textColor = UIColor.lightGray
        
        btnTrip.setFont(font: .Regular, size: 11)
        
        lblRating.setFont(font: .Regular, size: 10)
        self.lblParkDes.setFont(font: .Regular, size: 10)

        
//        lblPrice.setFont(font: .SemiBold, size: 14)
//        lblPrice.textColor = UIColor.black


       
//        self.imgRoom.layer.cornerRadius = 10.0
//        self.imgRoom.clipsToBounds = true
//        self.imgRoom.layer.borderColor = UIColor.lightGray.cgColor
//        self.imgRoom.layer.borderWidth = 0.3
        
        self.btnTrip.layer.cornerRadius = btnTrip.frame.size.height/2
        self.btnTrip.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        self.viewBgRating.layer.cornerRadius = 2.0
        self.viewBgRating.layer.masksToBounds = true
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.3
         
    }
    
    
}


