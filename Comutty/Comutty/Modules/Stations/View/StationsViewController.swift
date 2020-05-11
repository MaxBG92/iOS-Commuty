//
//  ViewController.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 8.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

protocol StationsViewInput: class {
    var stations: [StationViewModel] { get set }
    var filteredStations: [StationViewModel] { get set }

    func startLoading()
    func stopLoading()
}

protocol StationsViewOutput {
    func viewIsReady()
    func didSelectStationAtIndex(_ index: Int, filtered: Bool)
    func enteredSearch(_ text: String)
}

class StationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var output: StationsViewOutput?

    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    var filteredStations: [StationViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var stations: [StationViewModel] = [] {
        didSet {
            if stations.count == 0 {
                showEmptyState()
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        output?.viewIsReady()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Stations"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func showEmptyState() {
        let config = EmptyStateView.Configuration(image: UIImage(systemName: "tram.fill"),
                                                  text: "Sorry, we couldn't find any stations",
                                                  customView: nil)

        tableView.backgroundView = EmptyStateView(configuration: config)
    }

    private func stationForIndexPath(_ indexPath: IndexPath) -> StationViewModel {
        if isFiltering {
            return filteredStations[indexPath.row]
        } else {
            return stations[indexPath.row]
        }
    }
}

extension StationsViewController: StationsViewInput {
    func startLoading() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
    }

    func stopLoading() {
        if let activityIndicator = tableView.backgroundView as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}

extension StationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredStations.count : stations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
        let station = stationForIndexPath(indexPath)

        cell.textLabel?.text = station.title
        cell.detailTextLabel?.text = station.detail

        return cell
    }
}

extension StationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectStationAtIndex(indexPath.row, filtered: isFiltering)
    }
}

extension StationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        output?.enteredSearch(text)
    }
}
