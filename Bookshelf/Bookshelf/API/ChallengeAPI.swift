//
//  AppDelegate.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import Foundation

@objc final class ChallengeAPI: NSObject {
    let service: Service

    @objc convenience override init() {
        self.init(service: NetworkService())
    }

    init(service: Service) {
        self.service = service
    }

    func getNewBook(url: URL = APIRequests.newBooks.url, _ completion: @escaping (Result<[Book]>) -> Void) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let newBook: NewBook = try JSONDecoder().decode(NewBook.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(newBook.books))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.error(error))
                    }
                }
            case .error(let error):
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
    }
    
    func getBookDetail(isbn13: String, _ completion: @escaping (Result<BookDetail>) -> Void) {
        let url = APIRequests.bookDetail(isbn13).url
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let bookDetail: BookDetail = try JSONDecoder().decode(BookDetail.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(bookDetail))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.error(error))
                    }
                }
            case .error(let error):
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
    }
}

enum APIRequests {
    
    static let base = "https://api.itbook.store/1.0/"
    case newBooks
    case bookDetail(String)

    var stringValue: String {
        switch self {
        case .newBooks:
            return APIRequests.base + "new"
        case .bookDetail(let isbn13):
            return APIRequests.base + "books/" + isbn13
        }
    }

    var url: URL {
        return URL(string: stringValue)!
    }
}

enum APIError: Error {
    case noQuestions
}

// Only used for decoding
//private struct Questions: Codable {
//    let questions: [Question]
//}
