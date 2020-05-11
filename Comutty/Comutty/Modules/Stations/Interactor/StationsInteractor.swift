//
//  StationsInteractor.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

protocol StationsInteractorInput {
    func getStations()
}

protocol StationsInteractorOutput: class {
    func didGetStations(_ stations: [Station])
}

class StationsInteractor {
    weak var output: StationsInteractorOutput?
    private let webService: WebService

    init(webService: WebService) {
        self.webService = webService
    }
}

extension StationsInteractor: StationsInteractorInput {
    func getStations() {
        let request = StationsRequest()
        webService.perform(request) { [weak output] (result: Result<StationList, Error>) in
            switch result {
            case .success(let stationList):
                output?.didGetStations(stationList.stations)
            case .failure(let error):
                print(error)
            }
        }
    }
}
