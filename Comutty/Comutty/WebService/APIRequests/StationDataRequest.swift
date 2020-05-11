//
//  StationDataRequest.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

struct StationDataRequest: APIRequest {
    let path: String = "getStationDataByCodeXML"
    let quaryItems: [URLQueryItem]?

    init(stationCode: String) {
        quaryItems = [
            URLQueryItem(name: "StationCode", value: stationCode)
        ]
    }
}
