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

    var dataSource: BookDetail?
    var isbn13: String?
    var note = "Take a note"
    
    enum BookDetailSection: Int {
        case Description = 0
        case WebViewTakeNote = 1
        case Other = 2
        
        func rowNumber() -> Int {
            switch self {
            case .Description:
                return 1
            case .WebViewTakeNote:
                return 2
            case .Other:
                return 10
            }
        }
        
        func rowHeight() -> CGFloat {
            switch self {
            case .Description:
                return UITableView.automaticDimension
            case .WebViewTakeNote:
                return 100
            case .Other:
                return 60
            }
        }
        
        static func sectionCount() -> Int {
            return 3
        }
    }
    
    lazy var tableView: UITableView = { [unowned self] in
        let tView = UITableView(frame: .zero, style: UITableView.Style.plain)

        tView.estimatedRowHeight = 150
        tView.rowHeight = UITableView.automaticDimension
        
        tView.parallaxHeader.view = bookHeader
        tView.parallaxHeader.height = 300 - 84
        tView.parallaxHeader.minimumHeight = 84
        tView.parallaxHeader.mode = .topFill
        
        tView.backgroundColor = .white
        tView.delegate = self
        tView.dataSource = self
        tView.register(BaseTableViewCell.self, forCellReuseIdentifier: cellid)
        tView.register(UINib(nibName: "BookDetailDescriptionCell", bundle: nil), forCellReuseIdentifier: BookDetailDescriptionCell.identifier())
        return tView
    }()
    
    
    let bookHeader: BookDetailHeader = {
       let header = BookDetailHeader.bookDetailHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeApiCall()
        retriveNote()
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
    }
    
    fileprivate func retriveNote() {
        if let noteKey = isbn13, UserDefaults.standard.object(forKey: noteKey) != nil{
            note = UserDefaults.standard.object(forKey: noteKey) as! String
        }
    }
    
    fileprivate func makeApiCall() {
        startLoading(onView: view)
        ChallengeAPI().getBookDetail(isbn13: isbn13!) { (result) in
            switch result {
            case .error(let error):
                print(error)
            case .success(let bookDetail):
                self.stopLoading()
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
        return BookDetailSection.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pageSection = BookDetailSection(rawValue: section) else { return 0 }
        return pageSection.rowNumber()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pageSection = BookDetailSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch pageSection {
        case BookDetailSection.Description:
            let cell = tableView.dequeueReusableCell(withIdentifier: BookDetailDescriptionCell.identifier(), for: indexPath) as! BookDetailDescriptionCell
            cell.dataSource = dataSource
            return cell
        case BookDetailSection.WebViewTakeNote:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
            cell.textLabel?.textColor = UIColor.white
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.tealColor
            cell.textLabel?.numberOfLines = 0
            if indexPath.row == 0 {
                cell.textLabel?.text = "HyperLink: Go to webView"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = note
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            }
            return cell
        case .Other:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
            cell.textLabel?.text = "test cell with index: \(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let pageSection = BookDetailSection(rawValue: indexPath.section) else { return 0 }
        return pageSection.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pageSection = BookDetailSection(rawValue: indexPath.section) else { return }
        if pageSection == .WebViewTakeNote {
            if indexPath.row == 0 {
                let webController = WebController()
                webController.url = dataSource?.url
                navigationController?.pushViewController(webController, animated: true)
            }
            if indexPath.row == 1 {
                let takeNoteController = TakeNoteController()
                takeNoteController.delegate = self
                takeNoteController.isbn13 = dataSource?.isbn13
                takeNoteController.note = note
                navigationController?.pushViewController(takeNoteController, animated: true)
            }
        }
        
        
        
    }
    
}


extension BookDetailController: takeNoteDelegate {
    func didSavedNote(note: String) {
        self.note = note
        tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .middle)
    }
    
    
}


