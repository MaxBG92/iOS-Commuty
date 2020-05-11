//
//  TimetableViewController.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 10.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

struct TimetableViewData {
    let stationName: String?
    let trainViewModels: [TrainViewModel]
}

protocol TimetableViewInput: class {
    var viewData: TimetableViewData? { get set }

    func show(isLoading: Bool)
}

protocol TimetableViewOutput {
    func viewIsReady()
    func didTapStationButton()
    func selectedTrainAtIndex(_ index: Int)
    func requestRefresh()
}

class TimetableViewController: UIViewController, TimetableViewInput {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stationButton: UIButton!

    var output: TimetableViewOutput?

    var viewData: TimetableViewData? {
        didSet {
            showEmptyStateIfNeeded()
            updateStationButtonTitle()
            tableView.reloadData()
        }
    }

    private let refreshControl = UIRefreshControl()
    private let emptyStateConfiguration = EmptyStateView.Configuration(image: UIImage(systemName: "clock.fill"),
                                                                       text: "No trains available in the next 90 minutes",
                                                                       customView: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupStationButton()
        setupRefreshControl()

        output?.viewIsReady()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    private func setupStationButton() {
        stationButton.backgroundColor = .clear
        stationButton.layer.cornerRadius = 8
        stationButton.layer.borderWidth = 1
        stationButton.layer.borderColor = UIView.appearance().tintColor.cgColor
        stationButton.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @IBAction private func selectStationButtonTapped(_ sender: UIButton) {
        output?.didTapStationButton()
    }

    private func updateStationButtonTitle() {
        stationButton.setTitle(viewData?.stationName ?? "Select station", for: .normal)
    }

    private func showEmptyStateIfNeeded() {
        guard viewData?.trainViewModels.count == 0 else {
            tableView.backgroundView = nil
            return
        }

        let emptyStateView = EmptyStateView(configuration: emptyStateConfiguration)
        tableView.backgroundView = emptyStateView
    }

    @objc private func refresh() {
        output?.requestRefresh()
    }
}

extension TimetableViewController {
    func show(isLoading: Bool) {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.startAnimating()
            tableView.backgroundView = activityIndicator
        } else if let activityIndicator = tableView.backgroundView as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        } else {
            refreshControl.endRefreshing()
        }
    }
}

extension TimetableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableCell", for: indexPath) as? TimetableTableViewCell,
            let trainData = viewData?.trainViewModels[indexPath.row]
        else {
            assert(false, "Could not create cell")
            return UITableViewCell()
        }

        cell.trainCodeLabel.text = trainData.trainCode
        cell.titleLabel.text = trainData.title
        cell.leftDetailLabel.text = trainData.leftDetail
        cell.rightDetailLabel.text = trainData.rightDetail
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData?.trainViewModels.count ?? 0
    }
}

extension TimetableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.selectedTrainAtIndex(indexPath.row)
    }
}
