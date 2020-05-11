//
//  TimetablePresenter.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import Foundation

class TimetablePresenter: TimetableModuleInput {
    weak var view: TimetableViewInput?
    var interactor: TimetableInteractorInput?

    private let actionHandler: (TimetableModule.Action) -> Void

    private var trains: [StationTrainData] = [] {
        didSet {
            let trainViewModels = trains.map {
                TrainViewModel(train: $0)
            }
            view?.viewData = TimetableViewData(stationName: selectedStation?.name,
                                               trainViewModels: trainViewModels)
        }
    }

    var selectedStation: Station? {
        didSet {
            guard let station = selectedStation else {
                actionHandler(.openStations)
                return
            }

            interactor?.saveSelection(station: station)
            interactor?.fetchDataForStation(station)
        }
    }

    init(actionHandler: @escaping TimetableModule.ActionHandler) {
        self.actionHandler = actionHandler
    }
}

extension TimetablePresenter: TimetableViewOutput {

    func viewIsReady() {
        view?.show(isLoading: true)
        interactor?.loadSelection()
    }

    func didTapStationButton() {
        actionHandler(.openStations)
    }

    func selectedTrainAtIndex(_ index: Int) {
        let train = trains[index]
        actionHandler(.selectTrain(trainData: train))
    }

    func requestRefresh() {
        guard let station = selectedStation else {
            return
        }

        interactor?.fetchDataForStation(station)
    }
}

extension TimetablePresenter: TimetableInteractorOutput {
    func didFetchTrains(_ trains: [StationTrainData]) {
        view?.show(isLoading: false)
        self.trains = trains
    }

    func didLoadSelectedStation(_ station: Station?) {
        selectedStation = station
    }
}
