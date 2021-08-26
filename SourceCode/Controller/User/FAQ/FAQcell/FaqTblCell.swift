//
//  FaqTblCell.swift
//  Tappoo
//
//  Created by vishal.n on 05/02/20.
//  Copyright © 2020 Yesha. All rights reserved.
//

import UIKit

class FaqTblCell: UITableViewCell {
    
    @IBOutlet var lblQue : UILabel!
    @IBOutlet var lblAns : UILabel!
    @IBOutlet var imgArrow : UIImageView!
    
    @IBOutlet weak var lblLine: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblAns.font = Utility.SetRagular(Utility.TextField_Font_size())

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
