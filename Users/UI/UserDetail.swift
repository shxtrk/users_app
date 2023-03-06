//
//  UserDetail.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import SwiftUI

struct UserDetail: View {
    
    @EnvironmentObject var store: UsersStore
    
    var user: User
    var page: Int
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.thickMaterial)
                .ignoresSafeArea(edges: .top)
                .frame(height: 140)
            AvatarImage(avatar: user.avatar)
                .scaledToFit()
                .frame(width: 128, height: 128)
                .offset(y: -64)
                .padding(.bottom, -64)
                .shadow(radius: 6)
            HStack {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                FavoriteButton(set: user.favorite) {
                    Task(priority: .userInitiated) {
                        await store.send(.toggleFavorite(page, user))
                    }
                }
                .frame(width: 24, height: 24)
            }
            .padding(.top, 16)
            Text(user.email)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            Spacer()
        }
        .navigationTitle("\(user.firstName) \(user.lastName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let state = UsersStore.State(pages: [])
        let dependency = UsersStore.Dependency(usersClient: UsersClient.previewValue,
                                               usersPersistence: UsersPersistence.previewValue)
        let user = User(from: UserResponse.mock[0])
        
        UserDetail(user: user, page: 1)
            .environmentObject(UsersStore(state: state, dependency: dependency))
            .preferredColorScheme(.light)
        
        UserDetail(user: user, page: 1)
            .environmentObject(UsersStore(state: state, dependency: dependency))
            .preferredColorScheme(.dark)
    }
}


