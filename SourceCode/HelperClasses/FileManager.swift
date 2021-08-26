//
//  FileManager.swift
//  Monuments
//
//  Created by jayesh.d on 06/11/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit
import Photos

let APP_FM = FileManage.shared

class FileManage
{
    private init() {
        FM = FileManager.default
    }
    static let shared = FileManage()
    
    
    private var FM = FileManager()

    
    
}
