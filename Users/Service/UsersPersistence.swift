//
//  UsersPersistence.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import Foundation

// MARK: - Persistence Model

public struct UserData: Codable {
    public let id: Int
    public let email: String
    public let firstName: String
    public let lastName: String
    public let avatar: String
    public let favorite: Bool
}

public struct PageData: Codable {
    public let page: Int
    public let perPage: Int
    public let total: Int
    public let totalPages: Int
    public let data: [UserData]
}

// MARK: - Local Persistence

public struct UsersPersistence {
    
    // Use of UserDefaults used for demonstrative purposes
    // For production environment, replace with any local storage solution
    
    private static let userDefaults = UserDefaults.standard
    
    public var store: @Sendable (_ page: PageData) async throws -> Void
    public var retrieve: @Sendable (_ page: Int) async throws -> PageData?
}

// MARK: - Live Local Persistence

public extension UsersPersistence {
    static let liveValue = UsersPersistence { page in
        let data = try JSONEncoder().encode(page)
        userDefaults.set(data, forKey: String(page.page))
    } retrieve: { page in
        guard let data = userDefaults.data(forKey: String(page)) else {
            return nil
        }
        return try JSONDecoder().decode(PageData.self, from: data)
    }
}

// MARK: - Preview Local Persistence

public extension UsersPersistence {
    static let previewValue = UsersPersistence { _ in } retrieve: { _ in .mock }
}

// MARK: - Mock Data

public extension UserData {
    static var mock = [
        Self(id: 1,
             email: "george.bluth@reqres.in",
             firstName: "George",
             lastName: "Bluth",
             avatar: "https://reqres.in/img/faces/1-image.jpg",
             favorite: false),
        Self(id: 2,
             email: "janet.weaver@reqres.in",
             firstName: "Janet",
             lastName: "Weaver",
             avatar: "https://reqres.in/img/faces/2-image.jpg",
             favorite: false),
        Self(id: 3,
             email: "emma.wong@reqres.in",
             firstName: "Emma",
             lastName: "Wong",
             avatar: "https://reqres.in/img/faces/3-image.jpg",
             favorite: false),
        Self(id: 4,
             email: "eve.holt@reqres.in",
             firstName: "Eve",
             lastName: "Holt",
             avatar: "https://reqres.in/img/faces/4-image.jpg",
             favorite: false),
        Self(id: 5,
             email: "charles.morris@reqres.in",
             firstName: "Charles",
             lastName: "Morris",
             avatar: "https://reqres.in/img/faces/5-image.jpg",
             favorite: false),
        Self(id: 6,
             email: "tracey.ramos@reqres.in",
             firstName: "Tracey",
             lastName: "Ramos",
             avatar: "https://reqres.in/img/faces/6-image.jpg",
             favorite: false),
    ]
}

public extension PageData {
    static var mock = Self(page: 1,
                           perPage: 6,
                           total: 6,
                           totalPages: 1,
                           data: UserData.mock)
}
