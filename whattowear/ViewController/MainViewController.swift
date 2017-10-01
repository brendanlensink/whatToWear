//
//  MainViewController.swift
//  whattowear
//
//  Created by Brendan Lensink on 2017-09-23.
//  Copyright © 2017 wsiw. All rights reserved.
//

import UIKit
import SnapKit

private struct Margin {
    static let top = 44
    static let bottom = -top
    static let left = 11
    static let right = -left
}

private struct Padding {
    static let top = 16
    static let bottom = -top
}

class MainViewController: UIViewController {
    private var viewModel: MainViewModel!
    private var loadingView: UIView!
    private var displayView: UIView!
    private var headerLabel: UILabel!
    private var weatherImageView: UIImageView!
    private var footerLabel: UILabel!

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MainViewModel()

        let backgroundView = GradientView(frame: CGRect.zero)
        backgroundView.startColor = Color.Background.top
        backgroundView.endColor = Color.Background.bottom
        view.addSubview(backgroundView)

        backgroundView.snp.makeConstraints { make in make.edges.equalTo(view) }

        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = viewModel.getTitleText()
        titleLabel.font = Font.title
        titleLabel.textColor = Color.Text.secondary
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(Margin.top)
            make.leading.equalTo(view).offset(Margin.left)
            make.trailing.equalTo(view).offset(Margin.right)
        }

        displayView = UIView()
        displayView.isHidden = true
        view.addSubview(displayView)

        displayView.snp.makeConstraints { make in             make.top.equalTo(titleLabel.snp.bottom).offset(Padding.top)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(view).offset(Margin.bottom)
        }

        headerLabel = UILabel()
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.font = Font.header
        headerLabel.textColor = Color.Text.main
        displayView.addSubview(headerLabel)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Padding.top)
            make.leading.trailing.equalTo(titleLabel)
        }

        weatherImageView = UIImageView()
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.tintColor = Color.imageTint
        displayView.addSubview(weatherImageView)

        weatherImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(headerLabel.snp.bottom).offset(Padding.top)
        }

        footerLabel = UILabel()
        footerLabel.numberOfLines = 0
        footerLabel.textAlignment = .center
        footerLabel.font = Font.footer
        footerLabel.textColor = Color.Text.main
        displayView.addSubview(footerLabel)

        footerLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(Padding.top)
            make.leading.trailing.equalTo(headerLabel)
        }

        loadingView = UIView()
        view.addSubview(loadingView)

        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(displayView)
        }

        let loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.activityIndicatorViewStyle = .gray
        loadingSpinner.startAnimating()
        loadingView.addSubview(loadingSpinner)

        loadingSpinner.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(loadingView)
        }

        let loadingLabel = UILabel()
        loadingLabel.text = "Checking the weather..."
        loadingLabel.textAlignment = .center
        loadingView.addSubview(loadingLabel)

        loadingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(loadingSpinner.snp.top).offset(Padding.bottom)
            make.leading.trailing.equalTo(titleLabel)
            make.centerX.equalTo(loadingSpinner)
        }

        bindViewModel()
    }

    // MARK: Reactive Binding

    private func bindViewModel() {
        viewModel.responseSignal.observeValues { weatherResponse in
            self.loadingView.isHidden = true
            self.displayView.isHidden = false

            self.headerLabel.text = self.viewModel.getHeaderText(forWeather: weatherResponse)
            self.weatherImageView.image = self.viewModel.getWeatherImage(forWeather: weatherResponse)
            self.footerLabel.text = self.viewModel.getFooterText(forWeather: weatherResponse)
        }

        viewModel.errorSignal.observeValues { errorString in                                    let alert = UIAlertController(title: "Uh oh!", message: "Something went wrong \n \(errorString)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
