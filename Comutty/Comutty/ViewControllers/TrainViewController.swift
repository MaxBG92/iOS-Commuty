//
//  TrainViewController.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 10.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var webService: WebService?

    var trainID: String = ""

    var stops: [TrainStopData] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        fetchTrainData()
    }

    private func fetchTrainData() {
        let request = TrainDataRequest(trainID: trainID)
        webService?.perform(request, completion: { [weak self] (result: Result<TrainStopDataList, Error>) in
            switch result {
            case .success(let trainStopData):
                self?.stops = trainStopData.stops
            case .failure(let error):
                print(error)
            }
        })
    }
}

extension TrainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainCell", for: indexPath)
        let stop = stops[indexPath.row]

        let locationTitle = (stop.locationName ?? stop.locationCode)
        cell.textLabel?.text = "\(stop.locationOrder)\t\(locationTitle)"

        if stop.locationType == .destination {
            cell.detailTextLabel?.text = stop.expectedArrival
        } else {
            cell.detailTextLabel?.text = stop.expectedDeparture
        }

        return cell
    }
}
