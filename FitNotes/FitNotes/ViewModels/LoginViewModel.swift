//
//  LoginViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 08/07/2023.
//

import UIKit

class LoginViewModel {

    let dbManager: DatabaseManageable

    var error: ObservableObject<UIAlertController?> = ObservableObject(nil)

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func signInUser(email: String, password: String) {
        dbManager.signInUser(email: email, password: password) { [weak self] uId, error in
            guard let uId, error == nil else {
                self?.error.value = self?.errorFor(message: "Unsuccessful login. Please try again later")
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
