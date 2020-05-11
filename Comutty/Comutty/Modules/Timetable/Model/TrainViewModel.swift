//
//  TrainViewModel.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

struct TrainViewModel {
    let title: String
    let trainCode: String
    let leftDetail: String?
    let rightDetail: String?

    init(train: StationTrainData) {
        title = "\(train.origin) ➡ \(train.destination)"
        trainCode = train.trainCode

        if train.locationType != .origin {
            leftDetail = "Arriving:\t\(train.expectedArrival)"
        } else {
            leftDetail = nil
        }

        if train.locationType != .destination {
            rightDetail = "Departing:\t\(train.expectedDeparture)"
        } else {
            rightDetail = nil
        }
    }
}
