//
//  SearchController.swift
//  Bookshelf
//
//  Created by zijia on 10/12/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        type = .normal
        let searchBar = searchController.searchBar
        if let text = searchBar.text, text != "" {
            ChallengeAPI().getSearchResult(query: text, page: 1) { (result) in
                switch result {
                case .error(let err):
                    print(err)
                    self.dataSouce.removeAll()
                    self.tableView.reloadData()
                case .success(let books):
                    self.dataSouce.removeAll()
                    self.dataSouce = books
                    self.tableView.reloadData()
                }
            }
        } else {
            self.dataSouce.removeAll()
            self.tableView.reloadData()
        }
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        let category = Candy.Category(rawValue:
//            searchBar.scopeButtonTitles![selectedScope])
//        filterContentForSearchText(searchBar.text!, category: category)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        type = .detail
        self.tableView.reloadData()
    }
}


private let cellId = "cellId"

class SearchController: UITableViewController {
    
    var dataSouce = [Book]()
    var type: CellType = .normal
    
    enum CellType: Int {
        case normal = 0
        case detail = 1
        
        func rowHeight() -> CGFloat {
            switch self {
            case .normal:
                return 44
            case .detail:
                return BookCell.rowHeight()
            }
        }
    }
    
    lazy var searchController: UISearchController = { [unowned self] in
       let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.delegate = self
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        //prevent black screen
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dataSouce.count)
        return dataSouce.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .normal:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = dataSouce[indexPath.row].title
            return cell
        case .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier(), for: indexPath) as! BookCell
            cell.dataSource = dataSouce[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No data available..."
        label.textColor = UIColor.tealColor
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        print(dataSouce.isEmpty)
        return dataSouce.isEmpty ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return type.rowHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailController = BookDetailController()
        bookDetailController.isbn13 = dataSouce[indexPath.row].isbn13
        navigationController?.pushViewController(bookDetailController, animated: true)
    }

}
