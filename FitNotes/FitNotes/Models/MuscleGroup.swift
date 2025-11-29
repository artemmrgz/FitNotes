//
//  MuscleGroup.swift
//  FitNotes
//
//  Created by Artem Marhaza on 27/11/2025.
//

import Foundation

enum MuscleGroup: String, CaseIterable {
    case abs
    case back
    case biceps
    case calf
    case chest
    case forearms
    case legs
    case shoulders
    case triceps

    var title: String {
        rawValue.capitalized
    }

    var imageName: String {
        switch self {
        case .abs: "abs"
        case .back: "back"
        case .biceps: "bicep"
        case .calf: "abs"
        case .chest: "chest"
        case .forearms: "abs"
        case .legs: "abs"
        case .shoulders: "abs"
        case .triceps: "abs"
        }
    }
}
