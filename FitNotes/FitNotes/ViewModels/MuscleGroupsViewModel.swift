//
//  MuscleGroupsViewModel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 29/11/2025.
//

import Foundation

final class MuscleGroupsViewModel {

    let muscleGroups: [MuscleGroup] = MuscleGroup.allCases

    func numberOfMuscleGroups() -> Int {
        muscleGroups.count
    }

    func muscleGroup(at index: Int) -> MuscleGroup {
        muscleGroups[index]
    }
}
