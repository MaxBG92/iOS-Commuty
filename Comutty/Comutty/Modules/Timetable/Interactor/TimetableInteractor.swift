//
//  TimetableInteractor.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

protocol TimetableInteractorInput {
    func fetchDataForStation(_ station: Station)
    func saveSelection(station: Station)
    func loadSelection()
}

protocol TimetableInteractorOutput: class {
    func didFetchTrains(_ trains: [StationTrainData])
    func didLoadSelectedStation(_ station: Station?)
}

class TimetableInteractor {
    weak var output: TimetableInteractorOutput?
    private let webService: WebService

    private let storedSelectionKey = "LastSelectedStation"

    init(webService: WebService) {
        self.webService = webService
    }
}

extension TimetableInteractor: TimetableInteractorInput {
    func saveSelection(station: Station) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(station) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: storedSelectionKey)
        }
    }

    func loadSelection() {
        let defaults = UserDefaults.standard
        guard let savedStation = defaults.object(forKey: storedSelectionKey) as? Data else {
            output?.didLoadSelectedStation(nil)
            return
        }

        let decoder = JSONDecoder()
        if let loadedStation = try? decoder.decode(Station.self, from: savedStation) {
            output?.didLoadSelectedStation(loadedStation)
        } else {
            // Failed to decode stored station. Data may have changed
            defaults.removeObject(forKey: storedSelectionKey)
            output?.didLoadSelectedStation(nil)
        }
    }

    func fetchDataForStation(_ station: Station) {
        let request = StationDataRequest(stationCode: station.stationCode)
        webService.perform(request) { [weak output] (result: Result<StationTrainDataList, Error>) in
            switch result {
            case .success(let stationData):
                output?.didFetchTrains(stationData.trains)
            case .failure(let error):
                print(error)
            }
        }
    }
}
