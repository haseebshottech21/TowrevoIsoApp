//
//  CompanyInquierycell.swift
//  SourceCode
//
//  Created by Yesha on 04/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class CompanyInquierycell: UITableViewCell {

    
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
