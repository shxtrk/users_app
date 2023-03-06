//
//  UsersApp.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import SwiftUI

@main
struct UsersApp: App {
    
    @StateObject private var modelData = UsersStore(state: .init(pages: []),
                                                    dependency: .init(usersClient: UsersClient.liveValue))
    
    var body: some Scene {
        WindowGroup {
            UserList().environmentObject(modelData)
        }
    }
}
