//
//  Constant.swift
//  Bookshelf
//
//  Created by zijia on 10/13/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit


let zjScreenWidth: CGFloat = UIScreen.main.bounds.width
let zjScreenHeight: CGFloat = UIScreen.main.bounds.height
let isIphoneX = zjScreenHeight >= 812 ? true : false
let zjStatusHeight : CGFloat = isIphoneX ? 44 : 20
let zjNavigationBarHeight :CGFloat = 44
let zjTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49
