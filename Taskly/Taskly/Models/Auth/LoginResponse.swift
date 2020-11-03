//
//  LoginResponse.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import Foundation

struct LoginResponse: Decodable {
    let accessToken, tokenType, expiresAt: String
    let userData: UserData

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case userData = "user_data"
        case expiresAt = "expires_at"
    }
}

// MARK: - UserData
struct UserData: Codable {
    let id: Int
    let name, email, emailVerifiedAt, createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
