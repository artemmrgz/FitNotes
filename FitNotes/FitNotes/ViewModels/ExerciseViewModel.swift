//
//  ExerciseViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 30/06/2023.
//

import Foundation

enum ExerciseState {
    case idle
    case loaded
    case saved
    case setUpdated
    case setAdded
    case error(FNError)
}

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

    var state = ObservableObject<ExerciseState>(.idle)

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
                               date: nil, muscleGroup: muscleGroup) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let exercises):
                    print(exercises)
                    var filtered = [Exercise]()

                    for exercise in exercises where filtered.last?.name != exercise.name {
                        filtered.append(exercise)
                    }

                    self.exercises = filtered
                    self.state.value = .loaded

                case .failure(let error):
                    self.state.value = .error(error)
                }
            }
        }
    }

    func saveExercise() {
        guard let muscleGroup, let exerciseName, let date else { return }

        dbManager.getExercises(userId: userId, name: exerciseName,
                               date: date, muscleGroup: nil) { [weak self] result in
            guard let self else { return }

            var stats = self.statistics

            switch result {
            case .success(let exercises):
                if !exercises.isEmpty {
                    // there is only one exercise with the same name and date in DB by design
                    let existingStats = exercises[0].statistics
                    stats = self.mergeStatistics(existingStats, other: stats)
                }

                let exercise = Exercise(name: exerciseName, muscleGroup: muscleGroup,
                                        date: date, statistics: stats, id: "\(date)-\(exerciseName)")

                self.dbManager.addExercise(exercise, userId: self.userId) { [weak self] result in

                    switch result {
                    case .success():
                        self?.state.value = .saved
                    case .failure(let error):
                        self?.state.value = .error(error)
                    }
                }
            case .failure(let error):
                self.state.value = .error(error)
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
            state.value = .setUpdated
        } else {
            let stats = Statistics(sets: 1, repetitions: reps, weight: weight)
            statistics.append(stats)
            state.value = .setAdded
        }
    }

    func reset() {
        exerciseName = nil
        muscleGroup = nil
        reps = nil
        weight = nil
        statistics = []
        exercises = []
        state.value = .idle
    }
}
