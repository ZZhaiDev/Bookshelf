//
//  UINavigationControllerExtension.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import Foundation

@objc final class NewBook: NSObject, Codable {
    @objc let error: String
    @objc let total: String
    @objc let books: [Book]
}

@objc final class Book: NSObject, Codable {
    @objc let title: String
    @objc let subtitle: String
    @objc let isbn13: String
    @objc let price: String
    @objc let image: URL
    @objc let url: URL
}


@objc final class Search: NSObject, Codable {
    @objc let error: String
    @objc let total: String
    @objc let page: String
    @objc let books: [Book]
}
