//
//  ExerciseViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 30/06/2023.
//

import UIKit

class ExerciseViewModel {
    
    var muscleGroup: String?
    var exerciseName: String?
    var date: String?
    var sets = 0
    var reps = 0
    var weight = 0
    
    var exercises = [Exercise]()
    
    private var dbManager: DatabaseManageable!
    
    var error: ObservableObject<UIAlertController?> = ObservableObject(nil)
    var muscleGroupError: ObservableObject<Bool> = ObservableObject(false)
    
    var exercisesLoaded: ObservableObject<Bool> = ObservableObject(false)
    
    init(databaseManager: DatabaseManageable = DatabaseManager()) {
        self.dbManager = databaseManager
    }
    
    func getSavedExercises() {
        guard muscleGroup != nil else {
            muscleGroupError.value = true
            return
        }
        
        dbManager.getExercises(userId: "PX651xX3HabMChCyefEP", date: nil) { [weak self] result, err in
            if let err {
                self?.error.value = self?.errorFor(message: err.localizedDescription)
                return
            } else if let result {
                self?.exercises = result
                self?.exercisesLoaded.value = true
            }
        }
    }
    
    func errorFor(message: String) -> UIAlertController {
        let err = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        err.addAction(UIAlertAction(title: "OK", style: .cancel))
        return err
    }
}
