//
//  URLSession Extension.swift
//  ToDoList
//
//  Created by Артем Макар on 4.07.23.
//
import Foundation
extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation({ continuation in
            let task = self.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    }
                }
            }
            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        })
    }
}
