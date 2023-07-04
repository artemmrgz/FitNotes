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
    var exerciseSaved: ObservableObject<Bool> = ObservableObject(false)

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

    func getSavedExercisesByMuscleGroup() {
        guard muscleGroup != nil else {
            muscleGroupError.value = true
            return
        }

        dbManager.getExercises(userId: "PX651xX3HabMChCyefEP", name: nil,
                               date: nil, muscleGroup: muscleGroup) { [weak self] result, err in
            if let err {
                self?.error.value = self?.errorFor(message: err.localizedDescription)
                return
            } else if let result {
                self?.exercises = result
                self?.exercisesLoaded.value = true
            }
        }
    }

    func saveExercise() {
        guard let muscleGroup, let exerciseName, let date else { return }

        dbManager.getExercises(userId: "PX651xX3HabMChCyefEP", name: exerciseName,
                               date: date, muscleGroup: nil) { [weak self] result, err in
            guard let self else { return }

            var stats = self.statistics

            if let result, !result.isEmpty {
                // there is only one exercise with the same name and date in DB by design
                let existingStats = result[0].statistics

                stats = self.mergeStatistics(existingStats, other: self.statistics)
            }

            let exercise = Exercise(name: exerciseName, muscleGroup: muscleGroup,
                                    date: date, statistics: stats, id: "\(date)-\(exerciseName)")

            self.dbManager.addExercise(exercise, userId: "PX651xX3HabMChCyefEP") { [weak self] err in
                if let err {
                    self?.error.value = self?.errorFor(message: err.localizedDescription)
                } else {
                    self?.exerciseSaved.value = true
                }
            }
        }
    }

    private func mergeStatistics(_ firstStats: [Statistics], other secondStats: [Statistics]) -> [Statistics] {
        var secondStats = secondStats
        var result = firstStats

        for firstIdx in 0..<result.count {

            var secondIdx = 0
            while secondIdx < secondStats.count {

                if firstStats[firstIdx].repetitions == secondStats[secondIdx].repetitions &&
                    firstStats[firstIdx].weight == secondStats[secondIdx].weight {

                    // adding sets together from both statistics
                    result[firstIdx].sets = firstStats[firstIdx].sets + secondStats[secondIdx].sets

                    secondStats.remove(at: secondIdx)
                    secondIdx -= 1
                }
                secondIdx += 1
            }
        }
        result.append(contentsOf: secondStats)

        return result
    }

    func addNewSet() {
        guard let reps else { return }

        if !statistics.isEmpty && (statistics.last?.repetitions == reps && statistics.last?.weight == weight) {
            statistics[statistics.count - 1].sets += 1
            setUpdated.value = true
        } else {
            let stats = Statistics(sets: 1, repetitions: reps, weight: weight)
            statistics.append(stats)
            newSetAdded.value = true
        }
    }

    func errorFor(message: String) -> UIAlertController {
        let err = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        err.addAction(UIAlertAction(title: "OK", style: .cancel))
        return err
    }
}
