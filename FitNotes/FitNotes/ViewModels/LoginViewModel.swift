//
//  LoginViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 08/07/2023.
//

import UIKit

class LoginViewModel {

    let dbManager: DatabaseManageable

    var error: ObservableObject<FNError?> = ObservableObject(nil)
    var didLogin: ObservableObject<Bool> = ObservableObject(false)

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func signInUser(email: String, password: String) {
        dbManager.signInUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let uId):
                    self?.didLogin.value = true
                    UserDefaults().set(uId, forKey: Resources.userIdKey)
                case .failure(let error):
                    self?.error.value = error
                }
            }
        }
    }
}
