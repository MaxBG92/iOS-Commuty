//
//  StationsModule.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 11.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

class StationsModule {
    typealias ActionHandler = (Action) -> Void

    enum Action {
        case selectedStation(_ station: Station)
    }

    static func createModule(webService: WebService,
                             actionHandler: @escaping ActionHandler) -> UIViewController {
        let viewController = StationsViewController.instantiateFromStoryboard()
        let presenter = StationsPresenter(actionHandler: actionHandler)
        let interactor = StationsInteractor(webService: webService)

        viewController.output = presenter
        interactor.output = presenter

        presenter.view = viewController
        presenter.interactor = interactor

        return viewController
    }
}
