//
//  AppCoordinator.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 10.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

class AppCoordinator {
    private let navigationController: UINavigationController
    private weak var timetableInput: TimetableModuleInput?

    private lazy var webService: WebService = {
        WebService()
    }()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTimetable()
    }

    func showTimetable() {
        let actionHandler: TimetableModule.ActionHandler = { [weak self] action in
            switch action {
            case .openStations:
                self?.showStations()
            case .selectTrain(let stationTrainData):
                self?.showTrainDetails(train: stationTrainData)
            }
        }

        let (timetableViewController, input) = TimetableModule.createModule(webService: webService,
                                                                            actionHandler: actionHandler)

        navigationController.pushViewController(timetableViewController, animated: false)
        timetableInput = input
    }

    func showStations() {
        let actionHandler: StationsModule.ActionHandler = { [weak timetableInput, weak navigationController] action in
            switch action {
            case .selectedStation(let station):
                timetableInput?.selectedStation = station
                navigationController?.popViewController(animated: true)
            }
        }

        let stationsViewController = StationsModule.createModule(webService: webService,
                                                                 actionHandler: actionHandler)

        navigationController.pushViewController(stationsViewController, animated: true)
    }

    func showTrainDetails(train: StationTrainData) {
        let trainViewController = TrainViewController.instantiateFromStoryboard()
        trainViewController.webService = webService
        trainViewController.trainID = train.trainCode
        navigationController.pushViewController(trainViewController, animated: true)
    }
}
