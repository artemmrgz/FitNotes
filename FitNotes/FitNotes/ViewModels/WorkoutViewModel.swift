//
//  WorkoutViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 29/09/2023.
//

import UIKit

class WorkoutViewModel {

    let userId: String!

    var muscleGroups = [String]()
    var exerciseDetails = [[Exercise]]()

    private var dbManager: DatabaseManageable!

    var error: ObservableObject<UIAlertController?> = ObservableObject(nil)
    var exercisesLoaded: ObservableObject<Bool> = ObservableObject(false)

    init(databaseManager: DatabaseManageable = DatabaseManager.shared) {
        self.dbManager = databaseManager

        self.userId = UserDefaults.standard.string(forKey: Resources.userIdKey)
    }

    func getSavedExercises(date: String) {
        dbManager.getExercises(userId: userId, name: nil, date: date, muscleGroup: nil) { [weak self] result, err in

            guard let self, let result else {
                if let err {
                    self?.error.value = Errors.errorWith(message: err.localizedDescription)
                }
                return
            }

            (self.muscleGroups, self.exerciseDetails) = self.sortByMuscleGroup(result)
            self.exercisesLoaded.value = true
        }
    }

    func sortByMuscleGroup(_ exercises: [Exercise]) -> ([String], [[Exercise]]) {
        var names = [String]()
        var details = [[Exercise]]()

        var exercisesByMuscleGroup = [String: [Exercise]]()

        for exercise in exercises {
            if var mg = exercisesByMuscleGroup[exercise.muscleGroup] {
                mg.append(exercise)
                exercisesByMuscleGroup[exercise.muscleGroup] = mg
            } else {
                exercisesByMuscleGroup[exercise.muscleGroup] = [exercise]
            }
        }
        // since each section is accessed by index (is Int) in table view, we need to convert dict to
        // arrays
        for (name, info) in exercisesByMuscleGroup {
            names.append(name)
            details.append(info)
        }

        return (names, details)
    }
}
