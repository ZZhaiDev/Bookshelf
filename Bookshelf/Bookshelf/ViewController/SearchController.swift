//
//  SearchController.swift
//  Bookshelf
//
//  Created by zijia on 10/12/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit
private let cellId = "cellId"

class SearchController: UITableViewController {
    
    var dataSouce = [Book]()
    var type: CellType = .normal
    
    fileprivate var currentPage = 1
    fileprivate var searchText = ""
    fileprivate var loadMoreView: LoadMoreControl!
    
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
        self.definesPresentationContext = true                                      //prevent black screen
        navigationItem.searchController = searchController
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        loadMoreView = LoadMoreControl(scrollView: tableView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreView.delegate = self
    }

    
    fileprivate func makeAPICall() {
        if searchText != "" {
            ChallengeAPI().getSearchResult(query: searchText, page: currentPage) { (result) in
                switch result {
                case .error(let err):
                    print(err)
                case .success(let books):
                    if self.currentPage == 1 {
                        self.dataSouce.removeAll()
                        self.dataSouce = books
                        self.tableView.reloadData()
                    } else {
                        self.loadMoreView.stop()
                        let lastDataSourceCount = self.dataSouce.count - 1
                        var indexPaths = [IndexPath]()
                        books.forEach({ (book) in
                            indexPaths.append(IndexPath(row: self.dataSouce.count, section: 0))
                            self.dataSouce.append(book)
                        })
                        self.tableView.insertRows(at: indexPaths, with: .middle)
                        if self.dataSouce.count > lastDataSourceCount + 2 {
                            self.tableView.scrollToRow(at: IndexPath(row: lastDataSourceCount + 2, section: 0), at: .bottom, animated: true)
                        }
                    }
                }
            }
        } else {
            self.dataSouce.removeAll()
            self.tableView.reloadData()
        }
    }
}


extension SearchController: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentPage += 1
            self.makeAPICall()
        }
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        
    }
}


// dataSource, delegate
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if type == .detail {
            loadMoreView.didScroll()
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


extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        currentPage = 1
        type = .normal
        let searchBar = searchController.searchBar
        searchText = searchBar.text ?? ""
        makeAPICall()
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        type = .detail
        self.tableView.reloadData()
    }
}
