//
//  FavoriteButton.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import SwiftUI

struct FavoriteButton: View {
    
    let set: Bool
    let action: () -> Void
    
    var body: some View {
        Image(systemName: set ? "star.fill" : "star")
            .resizable()
            .foregroundColor(set ? .yellow : .gray)
            .onTapGesture { action() }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(set: true, action: {})
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        FavoriteButton(set: true, action: {})
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

