//
//  BookCell.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit

class BookCell: BaseTableViewCell {
    
    var dataSource: Book? {
        didSet {
            guard let dataSource = dataSource else { return }
            bookTitle.text = dataSource.title
            bookSubtitle.text = dataSource.subtitle
            bookPrice.text = dataSource.price
            UIImage.asyncFrom(url: dataSource.image, { (result) in
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .success(let image):
                    DispatchQueue.main.async {
                        self.bookImageView.image = image
                    }
                }
            })
        }
    }
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookSubtitle: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookImageView.contentMode = .scaleAspectFill
        bookImageView.clipsToBounds = true
    }
}
