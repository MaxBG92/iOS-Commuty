//
//  StationViewModel.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

struct StationViewModel {
    let title: String
    let detail: String

    init(station: Station) {
        title = station.displayName
        detail = station.stationCode
    }
}
