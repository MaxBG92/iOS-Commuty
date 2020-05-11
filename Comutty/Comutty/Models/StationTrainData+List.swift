//
//  StationTrainData+List.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 10.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

struct StationTrainData: Decodable, Equatable, Hashable {
    enum LocationType: String, Decodable {
        case origin = "O"
        case destination = "D"
        case stop = "S"
        case timingPoint = "T"
    }

    let trainCode: String
    let origin: String
    let destination: String
    let status: String
    let dueIn: Int
    let late: Int
    let expectedArrival: String
    let expectedDeparture: String
    let locationType: LocationType

    private enum CodingKeys: String, CodingKey {
        case trainCode = "Traincode"
        case origin = "Origin"
        case destination = "Destination"
        case status = "Status"
        case dueIn = "Duein"
        case late = "Late"
        case expectedArrival = "Exparrival"
        case expectedDeparture = "Expdepart"
        case locationType = "Locationtype"
    }

    static func == (lhs: StationTrainData, rhs: StationTrainData) -> Bool {
        return lhs.trainCode == rhs.trainCode
    }
}

struct StationTrainDataList: Decodable {
    let trains: [StationTrainData]

    enum CodingKeys: String, CodingKey {
        case trains = "objStationData"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            trains = try container.decode([StationTrainData].self, forKey: .trains)
        } catch let error {
            print(error)
            trains = []
        }
    }
}
