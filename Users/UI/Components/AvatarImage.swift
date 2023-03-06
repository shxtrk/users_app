//
//  AvatarImage.swift
//  Users
//
//  Created by Serhii Striuk on 06.03.2023.
//

import SwiftUI

struct AvatarImage: View {
    
    let avatar: String
    
    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: avatar)) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    Rectangle().fill(.thickMaterial)
                }
            }
            .cornerRadius(geometry.size.width * 0.2)
        }
    }
}

struct AvatarImage_Previews: PreviewProvider {
    static var previews: some View {
        AvatarImage(avatar: "https://reqres.in/img/faces/1-image.jpg")
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        AvatarImage(avatar: "https://reqres.in/img/faces/1-image.jpg")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
