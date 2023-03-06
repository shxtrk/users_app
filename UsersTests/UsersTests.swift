//
//  UsersTests.swift
//  UsersTests
//
//  Created by Serhii Striuk on 06.03.2023.
//

import XCTest
@testable import Users

@MainActor
final class UsersTests: XCTestCase {
    
    func testPageRefresh() async throws {
        let page = Page(from: PageResponse.mock)
        
        let store = SUT(for: [])
        
        XCTAssertTrue(store.state.pages.isEmpty)
        await store.send(.refresh)
        XCTAssertTrue(page == store.state.pages[0])
    }
    
    func testPageLoad() async throws {
        let page = Page(from: PageResponse.mock)
        
        let store = SUT(for: [])
        
        XCTAssertTrue(store.state.pages.isEmpty)
        await store.send(.loadPage)
        XCTAssertTrue(page == store.state.pages[0])
    }
    
    func testFavoriteToggle() async throws {
        let page = Page(from: PageResponse.mock)
        
        let store = SUT(for: [page])
        
        XCTAssertFalse(store.state.pages[0].users[0].favorite)
        await store.send(.toggleFavorite(page.id, page.users[0]))
        XCTAssertTrue(store.state.pages[0].users[0].favorite)
    }
}

private extension UsersTests {
    private func SUT(for pages: [Page]) -> UsersStore {
        UsersStore(state: .init(pages: pages),
                   dependency: .init(usersClient: UsersClient.previewValue,
                                     usersPersistence: UsersPersistence.previewValue))
    }
}
