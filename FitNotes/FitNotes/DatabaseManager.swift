//
//  DatabaseManager.swift
//  FitNotes
//
//  Created by Artem Marhaza on 29/06/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol DatabaseManageable {
    func addExercise(_ exercise: Exercise, userId: String, completion: @escaping (Result<Void, FNError>) -> Void)
    func getExercises(userId: String, name: String?, date: String?,
                      muscleGroup: String?, completion: @escaping (Result<[Exercise], FNError>) -> Void)
    func createUser(email: String, password: String, name: String,
                    completion: @escaping (Result<String, FNError>) -> Void)
    func signInUser(email: String, password: String, completion: @escaping (Result<String, FNError>) -> Void)
    func getUser(id userId: String, completion: @escaping (Result<User, FNError>) -> Void)
    func getCurrentUser() -> AuthUser?
}

class DatabaseManager: DatabaseManageable {

    static let shared = DatabaseManager()

    private let db = Firestore.firestore()
    private let auth = FirebaseAuth.Auth.auth()

    func createUser(email: String,
                    password: String,
                    name: String,
                    completion: @escaping (Result<String, FNError>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authDataResult, error in
            guard let result = authDataResult, error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            let firebaseUser = result.user
            guard let email = firebaseUser.email else {
                completion(.failure(.invalidData))
                return
            }

            let uid = firebaseUser.uid
            let user = User(email: email, name: name, id: uid)

            let userRef = self.db.collection("users").document(uid)

            do {
                try userRef.setData(from: user)
            } catch {
                completion(.failure(.writeError))
            }

            completion(.success(uid))
        }
    }

    func getCurrentUser() -> AuthUser? {
        guard let firebaseUser = auth.currentUser,
              let email = firebaseUser.email else { return nil }

        return AuthUser(email: email)
    }

    func getUser(id userId: String, completion: @escaping (Result<User, FNError>) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }

            guard let snapshot, snapshot.exists else {
                completion(.failure(.noUserFound))
                return
            }

            do {
                let user = try snapshot.data(as: User.self)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }

    func signInUser(email: String, password: String, completion: @escaping (Result<String, FNError>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }

            guard let result = authDataResult else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(result.user.uid))
        }
    }

    func addExercise(_ exercise: Exercise, userId: String, completion: @escaping (Result<Void, FNError>) -> Void) {
        guard let exerciseId = exercise.id else {
            completion(.failure(.invalidData))
                return
        }

        let exerciseRef = db.collection("users").document(userId).collection("exercises").document(exerciseId)

        do {
            try exerciseRef.setData(from: exercise)
            completion(.success(()))
        } catch {
            completion(.failure(.writeError))
        }
    }

    func getExercises(userId: String, name: String?, date: String?,
                      muscleGroup: String?, completion: @escaping (Result<[Exercise], FNError>) -> Void) {

        let exercisesRef = db.collection("users").document(userId).collection("exercises")

        var query: Query = exercisesRef

        if let name {
            query = query.whereField("name", isEqualTo: name)
        }

        if let date {
            query = query.whereField("date", isEqualTo: date)
        }

        if let muscleGroup {
            query = query.whereField("muscleGroup", isEqualTo: muscleGroup)
        }

        query.getDocuments { snapshot, error in
            if error != nil {
                 completion(.failure(.unableToComplete))
                 return
             }

            guard let snapshot else {
                completion(.failure(.invalidData))
                return
            }

            var exercises = [Exercise]()

            for document in snapshot.documents {
                do {
                    let exercise = try document.data(as: Exercise.self)
                    exercises.append(exercise)
                } catch {
                    completion(.failure(.invalidData))
                    return
                }
            }

            completion(.success(exercises))
        }
    }
}
