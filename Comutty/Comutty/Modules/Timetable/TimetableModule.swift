//
//  Timetable.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

protocol TimetableModuleInput: class {
    var selectedStation: Station? { get set }
}

class TimetableModule {
    typealias ActionHandler = (Action) -> Void

    enum Action {
        case openStations
        case selectTrain(trainData: StationTrainData)
    }

    static func createModule(webService: WebService,
                             actionHandler: @escaping ActionHandler) -> (UIViewController, TimetableModuleInput) {
        let viewController = TimetableViewController.instantiateFromStoryboard()
        let presenter = TimetablePresenter(actionHandler: actionHandler)
        let interactor = TimetableInteractor(webService: webService)

        viewController.output = presenter
        interactor.output = presenter

        presenter.view = viewController
        presenter.interactor = interactor

        return (viewController, presenter)
    }
}
