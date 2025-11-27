//
//  MainViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 10/07/2023.
//

import UIKit

class UserViewModel {

    var error: ObservableObject<FNError?> = ObservableObject(nil)
    var userName: ObservableObject<String> = ObservableObject("")

    private var dbManager: DatabaseManageable!

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func loadUserInfo() {
        guard let uid = UserDefaults.standard.string(forKey: Resources.userIdKey) else { return }
        dbManager.getUser(id: uid) { [weak self] result in

            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.userName.value = user.name
                case .failure(let error):
                    self?.error.value = error
                }
            }
        }
    }
}
