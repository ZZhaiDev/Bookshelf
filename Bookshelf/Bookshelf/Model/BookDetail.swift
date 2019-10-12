//
//  BookDetail.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import Foundation

@objc final class BookDetail: NSObject, Codable {
    @objc let error: String
    @objc let title: String
    @objc let subtitle: String
    
    @objc let authors: String
    @objc let publisher: String
    @objc let language: String
    
    @objc let isbn10: String
    @objc let isbn13: String
    @objc let pages: String
    
    @objc let year: String
    @objc let rating: String
    @objc let desc: String
    
    @objc let price: String
    @objc let image: String
    @objc let url: String
//    @objc let pdf: BookDetailPdf
}

//@objc final class BookDetailPdf: NSObject, Codable {
//    @objc let freeEbook: String
//
//    enum CodingKeys: String, CodingKey {
//        case freeEbook = "Free eBook"
//    }
//
//}

