//
//  ViewController.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit



class NewController: UITableViewController {
    
    var dataSource = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Book"
        makeAPICall()
    }


}


extension NewController {
    fileprivate func makeAPICall() {
        ChallengeAPI().getNewBook { (result) in
            switch result {
            case .error(let error):
                print(error.localizedDescription)
            case .success(let books):
                self.dataSource = books
                self.tableView.reloadData()
            }
        }
    }
}




extension NewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier(), for: indexPath) as! BookCell
        cell.dataSource = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailController = BookDetailController()
        bookDetailController.isbn13 = dataSource[indexPath.row].isbn13
        navigationController?.pushViewController(bookDetailController, animated: true)
    }
}

