//
//  AVConstant.swift
//  AVPlayer
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 Tsou. All rights reserved.
//

import Foundation
import UIKit

/*** 设备宽高 */
let k_ScreenWidth = UIScreen.main.bounds.size.width
let k_ScreenHeight = UIScreen.main.bounds.size.height

/*** 颜色 */
func k_Color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor.init(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: (a))
}
/*** 标题颜色 */
let k_TitColor = UIColor.init(red: 53/255.0, green: 53/255.0, blue: 53/255.0, alpha: 1.0)
/*** 副标题颜色 */
let k_SubTitColor = UIColor.init(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)


