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
            bookImageView?.addSubview(spinnerView)
            spinnerView.fillSuperview()
            UIImage.asyncFrom(url: dataSource.image, { (result) in
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .success(let image):
                    DispatchQueue.main.async {
                        self.spinnerView.removeFromSuperview()
                        self.bookImageView.image = image
                    }
                }
            })
//            bookImageView.loadImage(urlString: dataSource.image.absoluteString)
        }
    }
    
    @IBOutlet weak var bookImageView: CatchedImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookSubtitle: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    
    static func rowHeight() -> CGFloat {
        return 150
    }
    
    var spinnerView: UIView = {
        let spin = UIView()
        spin.backgroundColor = UIColor.white
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spin.center
        spin.addSubview(ai)
        return spin
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookImageView.contentMode = .scaleAspectFill
        bookImageView.clipsToBounds = true
    }
}
