//
//  MyInquiryCell.swift
//  SourceCode
//
//  Created by Yesha on 18/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class MyInquiryCell: UITableViewCell {

    
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var imglogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
