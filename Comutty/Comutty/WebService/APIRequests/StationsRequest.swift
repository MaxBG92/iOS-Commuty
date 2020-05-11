//
//  StationsRequest.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

struct StationsRequest: APIRequest {
    let path = "getAllStationsXML"
    let quaryItems: [URLQueryItem]? = nil
}
