//
//  Station+List.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 10.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

struct Station: Codable {
    let name: String
    let alias: String?
    let stationCode: String
    let id: Int

    var displayName: String {
        return alias ?? name
    }

    private enum CodingKeys: String, CodingKey {
        case name = "StationDesc"
        case alias = "StationAlias"
        case stationCode = "StationCode"
        case id = "StationId"
    }
}

struct StationList: Decodable {
    let stations: [Station]

    enum CodingKeys: String, CodingKey {
        case stations = "objStation"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            stations = try container.decode([Station].self, forKey: .stations)
        } catch let error {
            print(error)
            stations = []
        }
    }
}
