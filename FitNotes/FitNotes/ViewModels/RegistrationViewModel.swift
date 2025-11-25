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
    var didRegister: ObservableObject<Bool> = ObservableObject(false)

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func registerUser(email: String, password: String, name: String) {
        dbManager.createUser(email: email,
                            password: password,
                            name: name) { [weak self] uId, error in
            DispatchQueue.main.async {
                guard let uId, error == nil else {
                    self?.error.value = Errors.errorWith(
                        message: "Registration cannot be completed. Please try again later")
                    return
                }

                self?.didRegister.value = true
                UserDefaults().set(uId, forKey: Resources.userIdKey)
            }
        }
    }
}
