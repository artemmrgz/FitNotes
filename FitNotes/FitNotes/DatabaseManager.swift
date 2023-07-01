//
//  DatabaseManager.swift
//  FitNotes
//
//  Created by Artem Marhaza on 29/06/2023.
//

enum MuscleGroup: String, CaseIterable {
    case Abs
    case Back
    case Biceps
    case Chest
    case Legs
    case Shoulders
    case Triceps
}

import Foundation
import FirebaseFirestore

protocol DatabaseManageable {
    func addExercise(_ exercise: Exercise, userId: String, completion: @escaping (Error?) -> Void)
    func updateExercise(_ exercise: Exercise, userId: String, completion: @escaping (Error?) -> Void)
    func getExercises(userId: String, date: String?, completion: @escaping ([Exercise]?, Error?) -> Void)
}

class DatabaseManager: DatabaseManageable {
    
    static let shared = DatabaseManager()
    
    private let db = Firestore.firestore()
    
    func addExercise(_ exercise: Exercise, userId: String, completion: @escaping (Error?) -> Void) {
        let exercisesCollectionRef = db.collection("users").document(userId).collection("exercises")
        do {
            try exercisesCollectionRef.addDocument(from: exercise)
            completion(nil)
        } catch {
            print("Error writing city to Firestore: \(error)")
            completion(error)
        }
    }
    
    func updateExercise(_ exercise: Exercise, userId: String, completion: @escaping (Error?) -> Void) {
        if let exerciseId = exercise.id {
            let exerciseRef = db.collection("users").document(userId).collection("exercises").document(exerciseId)
            do {
                try exerciseRef.setData(from: exercise)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func getExercises(userId: String, date: String?, completion: @escaping ([Exercise]?, Error?) -> Void) {
        
        let exerciseQuery = db.collection("users").document(userId).collection("exercises")
        
        if let date {
            exerciseQuery.whereField("date", isEqualTo: date)
        }
        
        exerciseQuery.getDocuments { snapshot, error in
            if let error {
                completion(nil, error)
            } else {
                var exercises = [Exercise]()
                for document in snapshot!.documents {
                    
                    do {
                        let exercise = try document.data(as: Exercise.self)
                        exercises.append(exercise)
                    } catch {
                        print(error)
                    }
                }
                completion(exercises, nil)
            }
        }
    }
}
