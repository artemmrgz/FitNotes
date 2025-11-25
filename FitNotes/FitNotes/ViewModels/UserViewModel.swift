//
//  MainViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 10/07/2023.
//

import UIKit

class UserViewModel {

    var error: ObservableObject<UIAlertController?> = ObservableObject(nil)
    var userName: ObservableObject<String> = ObservableObject("")

    private var dbManager: DatabaseManageable!

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager
    }

    func loadUserInfo() {
        guard let uid = UserDefaults.standard.string(forKey: Resources.userIdKey) else { return }
        dbManager.getUser(id: uid) { [weak self] user, _ in
            
            DispatchQueue.main.async {
                guard let user else {
                    self?.error.value = Errors.errorWith(message: "Couldn't load user info")
                    return
                }

                self?.userName.value = user.name
            }
        }
    }
}
