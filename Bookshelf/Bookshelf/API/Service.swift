//
//  AppDelegate.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import Foundation

protocol Service {
    func get(url: URL, completion: @escaping (Result<Data>) -> Void)
}

final class NetworkService: Service {
    func get(url: URL, completion: @escaping (Result<Data>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.error(error))
                return
            }
            guard let data = data else {
                completion(.error(ServiceError.invalidData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

enum ServiceError: Error {
    case invalidData
}
