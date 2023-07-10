//
//  DatabaseManager.swift
//  FitNotes
//
//  Created by Artem Marhaza on 29/06/2023.
//

enum MuscleGroup: String, CaseIterable {
    case abs = "Abs"
    case back = "Back"
    case biceps = "Biceps"
    case chest = "Chest"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case triceps = "Triceps"
}

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol DatabaseManageable {
    func addExercise(_ exercise: Exercise, userId: String, completion: @escaping (Error?) -> Void)
    func getExercises(userId: String, name: String?, date: String?,
                      muscleGroup: String?, completion: @escaping ([Exercise]?, Error?) -> Void)
    func createUser(email: String, password: String, name: String, completion: @escaping (String?, Error?) -> Void)
    func signInUser(email: String, password: String, completion: @escaping (String?, Error?) -> Void)
    func getUser(id userId: String, completion: @escaping (User?, Error?) -> Void)
    func getCurrentUser() -> AuthUser?
}

class DatabaseManager: DatabaseManageable {

    static let shared = DatabaseManager()

    private let db = Firestore.firestore()
    private let auth = FirebaseAuth.Auth.auth()

    func createUser(email: String, password: String, name: String, completion: @escaping (String?, Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { authDataResult, error in
            guard let result = authDataResult, error == nil else {
                completion(nil, error)
                return
            }

            let firebaseUser = result.user
            guard let email = firebaseUser.email else { return }

            let uid = firebaseUser.uid
            let user = User(email: email, name: name, id: uid)

            let userRef = self.db.collection("users").document(uid)

            do {
                try userRef.setData(from: user)
            } catch {
                completion(nil, error)
            }

            completion(uid, nil)
        }
    }

    func getCurrentUser() -> AuthUser? {
        guard let firebaseUser = auth.currentUser,
              let email = firebaseUser.email else { return nil }

        return AuthUser(email: email)
    }

    func getUser(id userId: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let snapshot, snapshot.exists else {
                completion(nil, error)
                return
            }
            do {
                let user = try snapshot.data(as: User.self)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    func signInUser(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            guard let result = authDataResult, error == nil else {
                completion(nil, error)
                return
            }
            completion(result.user.uid, nil)
        }
    }

    func addExercise(_ exercise: Exercise, userId: String, completion: @escaping (Error?) -> Void) {
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

    func getExercises(userId: String, name: String?, date: String?,
                      muscleGroup: String?, completion: @escaping ([Exercise]?, Error?) -> Void) {

        let exercisesRef = db.collection("users").document(userId).collection("exercises")

        var query: Query = exercisesRef

        if let name {
            query = exercisesRef.whereField("name", isEqualTo: name)
        }

        if let date {
            query = exercisesRef.whereField("date", isEqualTo: date)
        }

        if let muscleGroup {
            query = exercisesRef.whereField("muscleGroup", isEqualTo: muscleGroup)
        }

        query.getDocuments { snapshot, error in
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
