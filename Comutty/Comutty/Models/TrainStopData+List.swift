//
//  TrainStopData + List.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 10.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

struct TrainStopData: Decodable {
    let trainCode: String
    let locationCode: String
    let locationOrder: Int
    let locationName: String?
    let expectedArrival: String
    let expectedDeparture: String
    let locationType: StationTrainData.LocationType
    
    enum CodingKeys: String, CodingKey {
        case trainCode = "TrainCode"
        case locationCode = "LocationCode"
        case locationOrder = "LocationOrder"
        case locationName = "LocationFullName"
        case expectedArrival = "ExpectedArrival"
        case expectedDeparture = "ExpectedDeparture"
        case locationType = "LocationType"
    }
}

struct TrainStopDataList: Decodable {
    let stops: [TrainStopData]

    enum CodingKeys: String, CodingKey {
        case stops = "objTrainMovements"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let stopsUnsorted = try container.decode([TrainStopData].self, forKey: .stops)
            stops = stopsUnsorted.sorted { $0.locationOrder < $1.locationOrder }
        } catch let error {
            print(error)
            stops = []
        }
    }
}
