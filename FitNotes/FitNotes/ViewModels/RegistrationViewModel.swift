//
//  RegistrationViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 08/07/2023.
//

import UIKit

class RegistrationViewModel {

    let dbManager: DatabaseManageable

    var error: ObservableObject<UIAlertController?> = ObservableObject(nil)

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func registerUser(email: String, password: String, name: String) {
        dbManager.createUser(email: email,
                            password: password,
                            name: name) { [weak self] uId, error in
            guard let uId, error == nil else {
                self?.error.value = self?.errorFor(message: "Registration cannot be completed. Please try again later")
                return
            }
            self?.error.value = nil

            UserDefaults().set(uId, forKey: Resources.userIdKey)
        }
    }

    func errorFor(message: String) -> UIAlertController {
        let err = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        err.addAction(UIAlertAction(title: "OK", style: .cancel))
        return err
    }
}
