//
//  UserModel.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 30/04/24.
//

import Foundation

// MARK: - User Model Response
struct UserResponse: Codable {
    var _id: String?
    var name: String?
    var email: String?
    var mobile: String?
    var gender: String?
}
