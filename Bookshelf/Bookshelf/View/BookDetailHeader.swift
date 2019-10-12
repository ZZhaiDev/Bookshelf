//
//  BookDetailHeader.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit

class BookDetailHeader: UIView {
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }
    
    static func bookDetailHeader() -> BookDetailHeader {
        return Bundle.main.loadNibNamed("BookDetailHeader", owner: nil, options: nil)?.first as! BookDetailHeader
    }
}
