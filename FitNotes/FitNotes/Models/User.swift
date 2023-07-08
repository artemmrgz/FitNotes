//
//  User.swift
//  FitNotes
//
//  Created by Artem Marhaza on 07/07/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    let email: String
    let name: String
    
    @DocumentID var id: String?
}
