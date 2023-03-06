//
//  UsersStore.swift
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
}

struct Page: Identifiable, Equatable {
    let id: Int
    let final: Bool
    var users: [User]
}

extension Page {
    init(from response: PageResponse) {
        self.id = response.page
        self.final = response.page == response.totalPages
        self.users = response.data.map { .init(from: $0) }
    }
}

@MainActor
class UsersStore: ObservableObject {
    
    init(state: State, dependency: Dependency) {
        self.state = state
        self.dependency = dependency
    }
    
    // MARK: - Dependency
    
    struct Dependency {
        let usersClient: UsersClient
    }
    
    var dependency: Dependency
    
    // MARK: - State
    
    struct State {
        var loading = false
        var pages: [Page]
    }
    
    @Published var state: State
    
    // MARK: - Actions
    
    enum Action {
        case refresh
        case loadPage
        case toggleFavorite(Int, User)
    }
    
    func send(_ action: Action) async {
        switch action {
        case .refresh:
            state.pages = []
            await load(page: 1)
            
        case .loadPage:
            guard !state.loading else { return }
            guard let lastPage = state.pages.last else {
                await self.send(.refresh)
                return
            }
            guard !lastPage.final else { return }
            await load(page: lastPage.id + 1)
            
        case .toggleFavorite(let page, let user):
            guard let page = state.pages.firstIndex(where: { $0.id == page }),
                  let user = state.pages[page].users.firstIndex(where: { $0.id == user.id })
            else { return }
            state.pages[page].users[user].favorite.toggle()
        }
    }
    
    // MARK: - Private
    
    private func load(page: Int) async {
        state.loading = true
        defer { state.loading = false }
        do {
            let page = try await self.dependency.usersClient.page(page)
            state.pages.append(Page(from: page))
        } catch _ { }
    }
}
