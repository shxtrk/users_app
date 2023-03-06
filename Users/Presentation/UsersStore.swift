//
//  UsersStore.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import Foundation

@MainActor
class UsersStore: ObservableObject {
    
    init(state: State, dependency: Dependency) {
        self.state = state
        self.dependency = dependency
    }
    
    // MARK: - Dependency
    
    struct Dependency {
        let usersClient: UsersClient
        let usersPersistence: UsersPersistence
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
            await refresh()
        case .loadPage:
            await loadPage()
        case .toggleFavorite(let page, let user):
            await toggleFavorite(page, user)
        }
    }
}

// MARK: - Actions

private extension UsersStore {
    private func refresh() async {
        state.pages = []
        await load(page: 1)
    }
    
    private func loadPage() async {
        guard !state.loading else { return }
        guard let lastPage = state.pages.last else {
            await self.send(.refresh)
            return
        }
        guard !lastPage.final else { return }
        await load(page: lastPage.id + 1)
    }
    
    private func toggleFavorite(_ page: Int, _ user: User) async {
        guard let page = state.pages.firstIndex(where: { $0.id == page }),
              let user = state.pages[page].users.firstIndex(where: { $0.id == user.id })
        else { return }
        state.pages[page].users[user].favorite.toggle()
        await store(PageData(from: state.pages[page]))
    }
}

// MARK: - Service

private extension UsersStore {
    private func store(_ page: PageData) async {
        do {
            try await dependency.usersPersistence.store(page)
        } catch { }
    }
    
    private func retrieve(_ page: Int) async -> PageData? {
        do {
            guard let data = try await dependency.usersPersistence.retrieve(page) else {
                return nil
            }
            return data
        } catch { return nil }
    }
    
    private func load(page: Int) async {
        
        func merge(_ source: Page, into destination: inout Page) {
            let favorites = source.users
                .enumerated()
                .filter { $0.element.favorite }
                .map { $0.offset }
            favorites.forEach { destination.users[$0].favorite = true }
        }
        
        state.loading = true
        if let data = await retrieve(page) {
            state.pages.append(Page(from: data))
        }
        
        do {
            let response = try await self.dependency.usersClient.page(page)
            state.loading = false
            var page = Page(from: response)
            if let index = state.pages.firstIndex(where: { page.id == $0.id }) {
                merge(state.pages[index], into: &page)
                state.pages[index] = page
            } else {
                state.pages.append(page)
            }
            await store(PageData(from: page))
        } catch { }
    }
}
