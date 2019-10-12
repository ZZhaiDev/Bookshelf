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
    let tableView = UITableView(frame: .zero)
    var dataSource: BookDetail?
    
    let bookHeader: BookDetailHeader = {
       let header = BookDetailHeader.bookDetailHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeApiCall()
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
        view.addSubview(tableView)
        tableView.fillSuperview()
        
//        tableView.estimatedRowHeight = 150
//        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.parallaxHeader.view = bookHeader
        tableView.parallaxHeader.height = 300 - 84
        tableView.parallaxHeader.minimumHeight = 84
        tableView.parallaxHeader.mode = .topFill
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        tableView.register(UINib(nibName: "BookDetailDescriptionCell", bundle: nil), forCellReuseIdentifier: BookDetailDescriptionCell.identifier())
    }
    
    fileprivate func makeApiCall() {
        ChallengeAPI().getBookDetail(isbn13: isbn13!) { (result) in
            switch result {
            case .error(let error):
                print(error)
            case .success(let bookDetail):
                self.dataSource = bookDetail
                self.bookHeader.dataSource = self.dataSource
                self.tableView.reloadData()
            }
            
        }
    }
}

extension BookDetailController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.title = (scrollView.contentOffset.y > -84) ? "Book Detail" : ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BookDetailDescriptionCell.identifier(), for: indexPath) as! BookDetailDescriptionCell
            cell.dataSource = dataSource
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return 100
    }
}


