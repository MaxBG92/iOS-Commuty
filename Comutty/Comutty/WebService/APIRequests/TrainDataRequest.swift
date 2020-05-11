//
//  TrainDataRequest.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

struct TrainDataRequest: APIRequest {
    let path: String = "getTrainMovementsXML"
    let quaryItems: [URLQueryItem]?

    init(trainID: String, date: Date = Date()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let dateString = formatter.string(from: date)

        quaryItems = [
            URLQueryItem(name: "TrainID", value: trainID),
            URLQueryItem(name: "TrainDate", value: dateString)
        ]
    }
}
