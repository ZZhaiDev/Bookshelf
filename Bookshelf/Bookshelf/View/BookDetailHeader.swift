//
//  BookDetailHeader.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit

class BookDetailHeader: UIView {
    
    var dataSource: BookDetail? {
        didSet {
            guard let dataSource = dataSource else { return }
            bookTitle.text = dataSource.title
            bookAuthor.text = dataSource.authors
            bookRating.text = "number of rating: \(dataSource.rating)"
            bookLanguage.text = dataSource.language
            bookYear.text = dataSource.year
            UIImage.asyncFrom(url: URL(string: dataSource.image)!, { (result) in
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .success(let image):
                    DispatchQueue.main.async {
                        self.bookImage.image = image
                    }
                }
            })
        }
    }
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookRating: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookLanguage: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        
        bookLanguage.layer.cornerRadius = 5
        bookLanguage.layer.masksToBounds = true
        
        bookYear.layer.cornerRadius = 5
        bookYear.layer.masksToBounds = true
    }
    
    static func bookDetailHeader() -> BookDetailHeader {
        return Bundle.main.loadNibNamed("BookDetailHeader", owner: nil, options: nil)?.first as! BookDetailHeader
    }
}
