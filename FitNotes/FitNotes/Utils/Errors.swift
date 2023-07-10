//
//  Errors.swift
//  FitNotes
//
//  Created by Artem Marhaza on 11/07/2023.
//

import UIKit

class Errors {
    static func errorWith(message: String) -> UIAlertController {
        let err = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        err.addAction(UIAlertAction(title: "OK", style: .cancel))
        return err
    }
}
