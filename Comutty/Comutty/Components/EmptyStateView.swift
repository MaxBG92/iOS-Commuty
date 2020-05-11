//
//  EmptyStateView.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 10.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    public struct Configuration {
        let image: UIImage?
        let text: String?
        let customView: UIView?
    }

    // MARK: Init

    init(configuration: Configuration) {
        imageView.image = configuration.image
        textLabel.text = configuration.text

        if let customView = configuration.customView {
            stackView.addArrangedSubview(customView)
        }
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    // MARK: - Subviews

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Setup

    private func setupLayout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let minimumPadding: CGFloat = 16

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: minimumPadding),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: minimumPadding),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -minimumPadding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -minimumPadding)
        ])

        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        textLabel.setContentHuggingPriority(.required, for: .vertical)
        textLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
}
