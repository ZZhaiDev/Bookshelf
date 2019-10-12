//
//  BookDetailController.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit



private let cellid = "cellid"

class BookDetailController: UIViewController {

    var isbn13: String?
    @IBOutlet weak var tableView: UITableView!
    
    let bookHeader: BookDetailHeader = {
       let header = BookDetailHeader.bookDetailHeader()
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(isbn13)
        ChallengeAPI().getBookDetail(isbn13: isbn13!) { (result) in
            switch result {
            case .error(let error):
                print(error)
            case .success(let bookDetail):
                print(bookDetail.authors)
                print(bookDetail.desc)
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        normalNavigationBar()
    }

}

// setupUI
extension BookDetailController {
    fileprivate func setupUI() {
        self.title = ""
        tableView.parallaxHeader.view = bookHeader
        tableView.parallaxHeader.height = 250 - 84
        tableView.parallaxHeader.minimumHeight = 84
        tableView.parallaxHeader.mode = .topFill
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
    }
}

extension BookDetailController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        self.title = (scrollView.contentOffset.y > -84) ? "Book Detail" : ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


