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
    var reps: Int?
    var weight: Int?
    
    var exercises = [Exercise]()
    var statistics = [Statistics]()
    
    private static var instance: ExerciseViewModel!
    private var dbManager: DatabaseManageable!
    
    var error: ObservableObject<UIAlertController?> = ObservableObject(nil)
    var muscleGroupError: ObservableObject<Bool> = ObservableObject(false)
    var exercisesLoaded: ObservableObject<Bool> = ObservableObject(false)
    var newSetAdded: ObservableObject<Bool> = ObservableObject(false)
    var setUpdated: ObservableObject<Bool> = ObservableObject(false)
    
    static func shared(_ dbManager: DatabaseManageable = DatabaseManager()) -> ExerciseViewModel {
        switch instance {
        case let i?:
            i.dbManager = dbManager
            return i
        default:
            instance = ExerciseViewModel(databaseManager: dbManager)
            return instance
        }
    }
    
    private init(databaseManager: DatabaseManageable) {
        self.dbManager = databaseManager
    }
    
    func getSavedExercises() {
        guard muscleGroup != nil else {
            muscleGroupError.value = true
            return
        }
        
        dbManager.getExercises(userId: "PX651xX3HabMChCyefEP", date: nil, muscleGroup: muscleGroup) { [weak self] result, err in
            if let err {
                self?.error.value = self?.errorFor(message: err.localizedDescription)
                return
            } else if let result {
                self?.exercises = result
                self?.exercisesLoaded.value = true
            }
        }
    }
    
    func increaseSetNumber() {
        guard !statistics.isEmpty else { return }
    
        statistics[statistics.count - 1].sets += 1
        setUpdated.value = true
    }
    
    func addSet() {
        guard let reps else { return }
        
        if !statistics.isEmpty && (statistics.last?.repetitions == reps && statistics.last?.weight == weight) {
            statistics[statistics.count - 1].sets += 1
        } else {
            let stats = Statistics(sets: 1, repetitions: reps, weight: weight)
            statistics.append(stats)
        }
        newSetAdded.value = true
    }
    
    func errorFor(message: String) -> UIAlertController {
        let err = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        err.addAction(UIAlertAction(title: "OK", style: .cancel))
        return err
    }
}
