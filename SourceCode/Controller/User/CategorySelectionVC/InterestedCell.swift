//
//  InterestedCell.swift
//  Vepye
//
//  Created by pratima on 11/09/20.
//  Copyright © 2020 Pratima. All rights reserved.
//

import UIKit

class InterestedCell: UITableViewCell {
    
    @IBOutlet var imgCell: UIImageView!
    @IBOutlet var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
