//
//  CollectionViewCell.swift
//  SourceCode
//
//  Created by Yesha on 05/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgview: UIView!
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
