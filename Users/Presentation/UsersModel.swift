//
//  UsersModel.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    
    var favorite: Bool
}

extension User {
    init(from response: UserResponse) {
        self.id = response.id
        self.email = response.email
        self.firstName = response.firstName
        self.lastName = response.lastName
        self.avatar = response.avatar
        
        self.favorite = false
    }
    
    init(from data: UserData) {
        self.id = data.id
        self.email = data.email
        self.firstName = data.firstName
        self.lastName = data.lastName
        self.avatar = data.avatar
        self.favorite = data.favorite
    }
}

extension UserData {
    init(from user: User) {
        self.id = user.id
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.avatar = user.avatar
        self.favorite = user.favorite
    }
}

struct Page: Identifiable, Equatable {
    let id: Int
    let final: Bool
    
    let perPage: Int
    let total: Int
    let totalPages: Int
    
    var users: [User]
}

extension Page {
    init(from response: PageResponse) {
        self.id = response.page
        self.final = response.page == response.totalPages
        self.perPage = response.perPage
        self.total = response.total
        self.totalPages = response.totalPages
        self.users = response.data.map { .init(from: $0) }
    }
    
    init(from data: PageData) {
        self.id = data.page
        self.final = data.page == data.totalPages
        self.perPage = data.perPage
        self.total = data.total
        self.totalPages = data.totalPages
        self.users = data.data.map { .init(from: $0) }
    }
}

extension PageData {
    init(from page: Page) {
        self.page = page.id
        self.perPage = page.perPage
        self.total = page.total
        self.totalPages = page.totalPages
        self.data = page.users.map { .init(from: $0) }
    }
}
