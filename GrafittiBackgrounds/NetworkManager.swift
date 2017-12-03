//
//  NetworkManager.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

class NetworkManager {
    enum NetworkError: Error {
        case noData
    }

    private let urlSession = URLSession(configuration: .default)
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()

    func send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())) {
        let operation = NetworkOperation()
        operation.task = urlSession.dataTask(with: request.url) { [weak operation] data, response, error in
            if let error = error {
                failure(error)
                operation?.finish()
                return
            }
            guard let data = data else {
                failure(NetworkError.noData)
                operation?.finish()
                return
            }
            do {
                let response = try request.createResponse(with: data)
                success(response)
                operation?.finish()
            } catch {
                failure(error)
                operation?.finish()
            }
        }
        queue.addOperation(operation)
    }

    func download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())) {
        let operation = NetworkOperation()
        operation.task = urlSession.downloadTask(with: url) { [weak operation] tempURL, response, error in
            if let error = error {
                failure(error)
                operation?.finish()
                return
            }
            guard let tempURL = tempURL else {
                failure(NetworkError.noData)
                operation?.finish()
                return
            }
            success(tempURL)
            operation?.finish()
        }
        queue.addOperation(operation)
    }

    func cancelAll() {
        queue.cancelAllOperations()
    }
}
