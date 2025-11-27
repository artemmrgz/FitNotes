//
//  Errors.swift
//  FitNotes
//
//  Created by Artem Marhaza on 11/07/2023.
//

import UIKit

enum FNError: String, Error {
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidData = "The data is invalid. Please try again."
    case writeError = "Unable to save user data. Please try again."
    case noUserFound = "The user was not found. Please try again."
}

extension FNError {
    var alert: UIAlertController {
        let alert = UIAlertController(title: "Error", message: self.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert
    }
}
