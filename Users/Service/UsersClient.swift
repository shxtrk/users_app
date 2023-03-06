//
//  UsersClient.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import Foundation

// MARK: - API Model

public struct UserResponse: Codable {
    public let id: Int
    public let email: String
    public let firstName: String
    public let lastName: String
    public let avatar: String
}

private extension UserResponse {
    enum CodingKeys: String, CodingKey {
        case id, email, avatar
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

public struct PageResponse: Codable {
    public let page: Int
    public let perPage: Int
    public let total: Int
    public let totalPages: Int
    public let data: [UserResponse]
}

private extension PageResponse {
    enum CodingKeys: String, CodingKey {
        case page, total, data
        case perPage = "per_page"
        case totalPages = "total_pages"
    }
}

// MARK: - API Client

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the remote feature to compile faster since it only depends on the interface.

public struct UsersClient {
    public var page: @Sendable (_ page: Int) async throws -> PageResponse
}

// MARK: - Live API Client

public extension UsersClient {
    static let liveValue = Self { page in
        var components = URLComponents(string: "https://reqres.in/api/users")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try jsonDecoder.decode(PageResponse.self, from: data)
    }
}

// MARK: - Preview API Client

public extension UsersClient {
    static let previewValue = Self { _ in .mock }
}

// MARK: - Private Helpers

private let jsonDecoder = JSONDecoder()

// MARK: - Mock Data

public extension UserResponse {
    static let mock = [
        Self(id: 1,
             email: "george.bluth@reqres.in",
             firstName: "George",
             lastName: "Bluth",
             avatar: "https://reqres.in/img/faces/1-image.jpg"),
        Self(id: 2,
             email: "janet.weaver@reqres.in",
             firstName: "Janet",
             lastName: "Weaver",
             avatar: "https://reqres.in/img/faces/2-image.jpg"),
        Self(id: 3,
             email: "emma.wong@reqres.in",
             firstName: "Emma",
             lastName: "Wong",
             avatar: "https://reqres.in/img/faces/3-image.jpg"),
        Self(id: 4,
             email: "eve.holt@reqres.in",
             firstName: "Eve",
             lastName: "Holt",
             avatar: "https://reqres.in/img/faces/4-image.jpg"),
        Self(id: 5,
             email: "charles.morris@reqres.in",
             firstName: "Charles",
             lastName: "Morris",
             avatar: "https://reqres.in/img/faces/5-image.jpg"),
        Self(id: 6,
             email: "tracey.ramos@reqres.in",
             firstName: "Tracey",
             lastName: "Ramos",
             avatar: "https://reqres.in/img/faces/6-image.jpg"),
    ]
}

public extension PageResponse {
    static let mock = Self(page: 1,
                           perPage: 6,
                           total: 6,
                           totalPages: 1,
                           data: UserResponse.mock)
}
