//
//  UserList.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import SwiftUI

struct UserList: View {
    
    @EnvironmentObject var store: UsersStore
    
    @State private var loaded = false
    @State private var favoritesOnly = false
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $favoritesOnly) {
                    Text("Favorites only")
                }
                ForEach(store.state.pages) { page in
                    ForEach(users(for: page)) { user in
                        NavigationLink {
                            UserDetail(user: user,
                                       page: page.id)
                        } label: {
                            UserRow(user: user) {
                                Task(priority: .userInitiated) {
                                    await store.send(.toggleFavorite(page.id, user))
                                }
                            }
                        }
                    }
                    .task { await store.send(.loadPage) }
                }
            }
            .navigationTitle("Users")
            .refreshable { await store.send(.refresh) }
            .task {
                guard !loaded else { return }
                loaded.toggle()
                await store.send(.refresh)
            }
        }
    }
    
    private func users(for page: Page) -> [User] {
        if favoritesOnly {
            return page.users.filter { $0.favorite }
        } else { return page.users }
    }
}

struct UserRow: View {
    
    var user: User
    let action: () -> Void
    
    var body: some View {
        HStack {
            AvatarImage(avatar: user.avatar)
                .frame(width: 64, height: 64)
            Text("\(user.firstName) \(user.lastName)")
                .foregroundColor(Color.primary)
            Spacer()
            FavoriteButton(set: user.favorite,
                           action: action)
                .frame(width: 24, height: 24)
                .padding(.horizontal, 16)
        }
    }
}

struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        let state = UsersStore.State(pages: [])
        let dependency = UsersStore.Dependency(usersClient: UsersClient.previewValue)
        
        UserList()
            .environmentObject(UsersStore(state: state,
                                          dependency: dependency))
            .preferredColorScheme(.light)
        
        UserList()
            .environmentObject(UsersStore(state: state,
                                          dependency: dependency))
            .preferredColorScheme(.dark)
    }
}
