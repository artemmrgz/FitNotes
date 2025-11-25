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

    let userId: String!
    private static var instance: ExerciseViewModel!
    private var dbManager: DatabaseManageable!

    var error: ObservableObject<UIAlertController?> = ObservableObject(nil)
    var exercisesLoaded: ObservableObject<Bool> = ObservableObject(false)
    var newSetAdded: ObservableObject<Bool> = ObservableObject(false)
    var setUpdated: ObservableObject<Bool> = ObservableObject(false)
    var exerciseSaved: ObservableObject<Bool> = ObservableObject(false)

    static func shared(_ dbManager: DatabaseManageable = DatabaseManager.shared) -> ExerciseViewModel {
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

        self.userId = UserDefaults.standard.string(forKey: Resources.userIdKey)
    }

    func getSavedExercisesByMuscleGroup() {
        guard muscleGroup != nil else { return }

        dbManager.getExercises(userId: userId, name: nil,
                               date: nil, muscleGroup: muscleGroup) { [weak self] result, err in
            DispatchQueue.main.async {
                if let err {
                    self?.error.value = Errors.errorWith(message: err.localizedDescription)
                    return
                } else if let result {

                    var filtered = [Exercise]()

                    if !result.isEmpty {
                        for idx in 0..<result.count - 1 where result[idx].name != result[idx + 1].name {
                            filtered.append(result[idx])
                        }

                        filtered.append(result[result.count - 1])
                    }

                    self?.exercises = filtered

                    self?.exercisesLoaded.value = true
                }
            }
        }
    }

    func saveExercise() {
        guard let muscleGroup, let exerciseName, let date else { return }

        dbManager.getExercises(userId: userId, name: exerciseName,
                               date: date, muscleGroup: nil) { [weak self] result, err in
            guard let self else { return }

            var stats = self.statistics

            if let result, !result.isEmpty {
                // there is only one exercise with the same name and date in DB by design
                let existingStats = result[0].statistics

                stats = self.mergeStatistics(existingStats, other: stats)
            }

            let exercise = Exercise(name: exerciseName, muscleGroup: muscleGroup,
                                    date: date, statistics: stats, id: "\(date)-\(exerciseName)")

            self.dbManager.addExercise(exercise, userId: self.userId) { [weak self] err in
                if let err {
                    self?.error.value = Errors.errorWith(message: err.localizedDescription)
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

    func reset() {
        exerciseName = nil
        muscleGroup = nil
        reps = nil
        weight = nil
        statistics = []
        exercises = []
        exercisesLoaded.value = false
        exerciseSaved.value = false
        newSetAdded.value = false
        setUpdated.value = false
        error.value = nil
    }
}
