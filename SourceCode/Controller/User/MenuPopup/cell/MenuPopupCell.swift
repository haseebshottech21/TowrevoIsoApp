//
//  MenuPopupCell.swift
//  SocialBug
//
//  Created by vishal.n on 16/06/20.
//  Copyright © 2020 Yesha. All rights reserved.
//

import UIKit

class MenuPopupCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblTitle.font = Utility.SetSemiBold(Utility.TextField_Font_size() - 1)
        lblTitle.textColor = UIColor.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
