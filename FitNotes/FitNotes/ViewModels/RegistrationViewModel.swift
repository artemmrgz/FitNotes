//
//  RegistrationViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 08/07/2023.
//

import Foundation

class RegistrationViewModel {

    let dbManager: DatabaseManageable

    var error: ObservableObject<FNError?> = ObservableObject(nil)
    var didRegister: ObservableObject<Bool> = ObservableObject(false)

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func registerUser(email: String, password: String, name: String) {
        dbManager.createUser(email: email,
                            password: password,
                            name: name) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let uId):
                    self?.didRegister.value = true
                    UserDefaults().set(uId, forKey: Resources.userIdKey)
                case .failure(let error):
                    self?.error.value = error
                }
            }
        }
    }
}
