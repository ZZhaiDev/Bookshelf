//
//  AppDelegate.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
