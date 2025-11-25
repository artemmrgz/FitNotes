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
    var didLogin: ObservableObject<Bool> = ObservableObject(false)

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func signInUser(email: String, password: String) {
        dbManager.signInUser(email: email, password: password) { [weak self] uId, error in
            DispatchQueue.main.async {
                guard let uId, error == nil else {
                    self?.error.value = Errors.errorWith(message: "Unsuccessful login. Please try again later")
                    return
                }

                self?.didLogin.value = true
                UserDefaults().set(uId, forKey: Resources.userIdKey)
            }
        }
    }
}
