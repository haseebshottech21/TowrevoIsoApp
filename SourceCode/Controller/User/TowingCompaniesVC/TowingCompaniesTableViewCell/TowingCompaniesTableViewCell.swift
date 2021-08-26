//
//  TowingCompaniesTableViewCell.swift
//  SourceCode
//
//  Created by Yesha on 11/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class TowingCompaniesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTimings: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnGetDirection: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewContent.backgroundColor = APP_COL.APP_Faded_White
        viewContent.roundCorner(value: 15.0)
        viewContent.layer.borderWidth = 1.0
        viewContent.layer.borderColor = (APP_COL.APP_Color).cgColor
        
        lblTimings.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        lblTimings.textColor = APP_COL.APP_LabelGrey
        
        lblDistance.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        
        
        lblCompanyName.font = Utility.SetBold(Utility.Header_Font_size() + 2)
        lblCompanyName.textColor = APP_COL.APP_Black_Color
        
        lblDescription.font = Utility.SetRagular(Utility.Small_size_12())
        lblDescription.textColor = APP_COL.APP_Black_Color
        
        btnGetDirection.setTitle(APP_LBL.get_direction, for: .normal)
        btnGetDirection.titleLabel?.font = Utility.SetBold(Utility.Small_size_12())
        btnGetDirection.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        imgLogo.round()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
