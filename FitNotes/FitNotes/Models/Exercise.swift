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
    var statistics: [Statistics]
    
    @DocumentID var id: String?
}

struct Statistics: Codable {
    var sets: Int
    let repetitions: Int
    let weight: Int?
}
