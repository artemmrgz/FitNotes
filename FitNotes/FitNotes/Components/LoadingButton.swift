//
//  LoadingButton.swift
//  FitNotes
//
//  Created by Artem Marhaza on 09/07/2023.
//

import UIKit

class LoadingButton: UIButton {

    private var buttonText: String?
    var activityIndicator: UIActivityIndicatorView!

    func showLoading() {
        buttonText = self.titleLabel?.text
        self.setTitle("", for: .normal)

        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }

        showSpinnig()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        self.setTitle(buttonText, for: .normal)
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Resources.Color.rosyBrown
        return activityIndicator
    }

    private func showSpinnig() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
