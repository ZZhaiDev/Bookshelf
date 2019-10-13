//
//  BookDetailDescriptionCell.swift
//  Bookshelf
//
//  Created by zijia on 10/12/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit

class BookDetailDescriptionCell: BaseTableViewCell {
    
    var dataSource: BookDetail? {
        didSet {
            guard let dataSource = dataSource else { return }
            priceButton.setTitle(dataSource.price, for: .normal)
            descriptionLabel.text = dataSource.desc
        }
    }
    
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceButton.layer.cornerRadius = priceButton.frame.height/2
        priceButton.layer.masksToBounds = true
        priceButton.setTitleColor(UIColor.white, for: .normal)
        priceButton.backgroundColor = UIColor.lightRed
    }
    
}
