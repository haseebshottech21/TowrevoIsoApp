//
//  Color.swift
//  Monuments
//
//  Created by jayesh.d on 22/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit

let APP_COL = Color.shared
class Color
{
    private init() { }
    static let shared = Color()
    
    
    
    //MARK:- Basic
    
    let App = APP_FUNC.getColorFromRGB(red: 2, green: 129, blue: 239, alpha: 1.0) //0281EF
    let APP_Black_Color = APP_FUNC.getColorFromRGB(red: 27, green: 27, blue: 27, alpha: 1.0)
    let APP_Color = APP_FUNC.getColorFromRGB(red: 18, green: 85, blue: 112, alpha: 1.0)
    let APP_White_Color = APP_FUNC.getColorFromRGB(red: 255, green: 255, blue: 255, alpha: 1.0)
    let APP_Grey_Color = APP_FUNC.getColorFromRGB(red: 128, green: 133, blue: 139, alpha: 1.0)
    let APP_DarkGrey_Color = APP_FUNC.getColorFromRGB(red: 86, green: 86, blue: 86, alpha: 1.0)
    let APP_Faded_White = APP_FUNC.getColorFromRGB(red: 248.0, green: 253.0, blue: 255.0, alpha: 1)
    let APP_LabelGrey = APP_FUNC.getColorFromRGB(red: 85.0, green: 95.0, blue: 106, alpha: 1)
    let APP_Textfield_Color = APP_FUNC.getColorFromRGB(red: 109.0, green: 116.0, blue: 122.0, alpha: 1.0)


    let NavBG = APP_FUNC.getColorFromRGB(red: 255, green: 255, blue: 255, alpha: 1.0)
    let NavTitle = APP_FUNC.getColorFromRGB(red: 0, green: 0, blue: 0, alpha: 1.0)
    
    let No_Data_Found = APP_FUNC.getColorFromRGB(red: 0, green: 0, blue: 0, alpha: 1.0)
    
    let White = APP_FUNC.getColorFromRGB(red: 255, green: 255, blue: 255, alpha: 1.0)
    let Black = APP_FUNC.getColorFromRGB(red: 0, green: 0, blue: 0, alpha: 1.0)
    let LineSeperator = APP_FUNC.getColorFromRGB(red: 241, green: 241, blue: 241, alpha: 1.0)
    
    
    let YellowColorPremium = APP_FUNC.getColorFromRGB(red: 218, green: 165, blue: 32, alpha: 1.0)
    
    let txtBGcolor = APP_FUNC.getColorFromRGB(red: 247, green: 248, blue: 249, alpha: 1.0)

    
    
    
    //MARK:- Textfield Aniumation property
    
    let TxtSelDevider = UIColor.lightGray
    let TxtUnSelDevider = UIColor.darkGray
    
    let TxtUnSelPlaceHolder = UIColor.darkGray
    let TxtSelPlaceHolder = UIColor.darkGray
    
    let TxtText = APP_FUNC.getColorFromRGB(red: 0, green: 0, blue: 0, alpha: 1.0)
    
    
    //MARK:- Tabbar
    let tab_sel = APP_FUNC.getColorFromRGB(red: 246, green: 201, blue: 0, alpha: 1.0)
    let tab_unsel = APP_FUNC.getColorFromRGB(red: 129, green: 129, blue: 129, alpha: 1.0)
    
    
    //MARK:- Login
    let login_descr = APP_FUNC.getColorFromRGB(red: 129, green: 129, blue: 129, alpha: 1.0)
    let or_login_with = APP_FUNC.getColorFromRGB(red: 113, green: 113, blue: 113, alpha: 1.0)
    
    
    //MARK:- Button
    let grad_start = APP_FUNC.getColorFromRGB(red: 243, green: 168, blue: 4, alpha: 1.0)
    let grad_end = APP_FUNC.getColorFromRGB(red: 246, green: 201, blue: 0, alpha: 1.0)
    
    
    let chat_devider = APP_FUNC.getColorFromRGB(red: 194, green: 194, blue: 194, alpha: 1.0)
    let gray = APP_FUNC.getColorFromRGB(red: 140, green: 140, blue: 140, alpha: 1.0)
    
    //let temp = APP_FUNC.getColorFromRGB(red: 00, green: 00, blue: 00, alpha: 1.0)
    //Notificaiton read/unread
    let not_unread = APP_FUNC.getColorFromRGB(red: 245, green: 191, blue: 23, alpha: 1.0)
    let not_read = APP_FUNC.getColorFromRGB(red: 51, green: 51, blue: 51, alpha: 1.0)
    let not_descr = APP_FUNC.getColorFromRGB(red: 163, green: 163, blue: 163, alpha: 1.0)
    let not_devider = APP_FUNC.getColorFromRGB(red: 163, green: 163, blue: 163, alpha: 1.0)
    
    //chat module
    let chatMessage = APP_FUNC.getColorFromRGB(red: 85, green: 85, blue: 85, alpha: 1.0)
    let chatBgView = APP_FUNC.getColorFromRGB(red: 226, green: 242, blue: 253, alpha: 1.0)
    
    let c_117 = APP_FUNC.getColorFromRGB(red: 117, green: 117, blue: 117, alpha: 1.0)
    let c_150 = APP_FUNC.getColorFromRGB(red: 150, green: 150, blue: 150, alpha: 1.0)
    
    //chat module
       let chatTime = APP_FUNC.getColorFromRGB(red: 126, green: 126, blue: 126, alpha: 1.0)
       let messageTime = APP_FUNC.getColorFromRGB(red: 158, green: 161, blue: 178, alpha: 1.0)
    
   
    
}
