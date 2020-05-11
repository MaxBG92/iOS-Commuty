//
//  StationsPresenter.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

class StationsPresenter {
    weak var view: StationsViewInput?
    var interactor: StationsInteractorInput?

    private var actionHandler: StationsModule.ActionHandler

    private var filteredStations: [Station] = [] {
        didSet {
            view?.filteredStations = filteredStations.map { StationViewModel(station: $0) }
        }
    }

    private var stations: [Station] = [] {
        didSet {
            view?.stations = stations.map { StationViewModel(station: $0) }
        }
    }

    init(actionHandler: @escaping StationsModule.ActionHandler) {
        self.actionHandler = actionHandler
    }
}

extension StationsPresenter: StationsViewOutput {
    func viewIsReady() {
        view?.startLoading()
        interactor?.getStations()
    }

    func didSelectStationAtIndex(_ index: Int, filtered: Bool) {
        let station: Station
        if filtered {
            station = filteredStations[index]
        } else {
            station = stations[index]
        }

        actionHandler(.selectedStation(station))
    }

    func enteredSearch(_ text: String) {
        filteredStations = stations.filter { (station: Station) -> Bool in
            let lowerCasedSearch = text.lowercased()
            return station.name.lowercased().contains(lowerCasedSearch)
                || station.alias?.lowercased().contains(lowerCasedSearch) ?? false
                || station.stationCode.lowercased().contains(lowerCasedSearch)
        }
    }
}

extension StationsPresenter: StationsInteractorOutput {
    func didGetStations(_ stations: [Station]) {
        self.stations = stations.sorted(by: { $0.name < $1.name })
    }
}
