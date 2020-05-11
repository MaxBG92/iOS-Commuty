//
//  WebService.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 8.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation
import XMLParsing

let baseURL = "http://api.irishrail.ie/realtime/realtime.asmx"

protocol APIRequest {
    var path: String { get }
    var quaryItems: [URLQueryItem]? { get }
}

class WebService {
    func perform<T: Decodable>(_ endpoint: APIRequest, completion: @escaping (Result<T, Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "api.irishrail.ie"
        urlComponents.path = "/realtime/realtime.asmx/\(endpoint.path)"
        urlComponents.queryItems = endpoint.quaryItems

        guard let url = urlComponents.url else {
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    print("No data")
                    return
                }

                do {
                    let response = try XMLDecoder().decode(T.self, from: data)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }

        dataTask.resume()
    }
}
