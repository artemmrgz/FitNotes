//
//  Exercise.swift
//  FitNotes
//
//  Created by Artem Marhaza on 01/07/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Exercise: Codable {
    let name: String
    let muscleGroup: String
    let date: String
    let sets: Int
    let repetitions: Int
    let weight: Int

    @DocumentID var id: String?
}
