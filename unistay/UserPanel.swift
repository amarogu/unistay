//
//  Profile.swift
//  unistay
//
//  Created by Gustavo Amaro on 21/08/23.
//

import SwiftUI
struct User {
    var id: UUID = UUID()
    var name: String
    var surname: String
    var username: String
    var bio: String
    var amountOfConnections: Int
}

struct UserPanel: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var imageSize: CGFloat = 0
    var user: User = .init(name: "Lucca", surname: "Gray", username: "luccagray", bio: "Adventurous soul with a love for books and food. Let's connect and share our stories! 🌍📚🍽️", amountOfConnections: 14)
    var body: some View {
        GeometryReader {
            geo in
            var width = geo.size.width
            VStack {
                ZStack(alignment: .bottomLeading) {
                    Image("ProfileBackground").resizable().aspectRatio(contentMode: .fill).frame(width: width, height: 90).scaleEffect(1.15).clipped().cornerRadius(20)
                    Image("ProfilePicture").resizable().aspectRatio(contentMode: .fill).frame(width: width * 0.2, height: width * 0.2).scaleEffect(1).clipShape(Circle()).overlay(Circle().stroke(Color("Gray"), lineWidth: 3.5)).background(GeometryReader {
                        geo in
                        Color.clear.onAppear {
                            imageSize = geo.size.width
                        }
                    }).offset(.init(width: imageSize / 2, height: imageSize / 2))
                    
                }.frame(maxWidth: .infinity).background(Color("BackgroundColor"))
                Spacer()
                HStack (alignment: .center) {
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 2) {
                            styledText(type: "Semibold", size: 16, content: "\(user.name) \(user.surname)")
                            styledText(type: "Regular", size: 14, content: "@\(user.username)").foregroundColor(Color("Body"))
                        }
                        styledText(type: "Regular", size: 14, content: user.bio).frame(maxWidth: width * 0.6).padding(.trailing, width * 0.4)
                        Button (action: {
                            
                        }) {
                            HStack {
                                styledText(type: "Regular", size: 14, content: "See \(user.name)'s full bio").foregroundColor(Color("Body"))
                                Image(systemName: "doc.badge.ellipsis").foregroundColor(Color("Body"))
                            }
                        }
                        HStack {
                            styledText(type: "Semibold", size: 14, content: "\(user.amountOfConnections)")
                            styledText(type: "Regular", size: 14, content: "Connections")
                        }
                    }
                    Spacer()
                    
                }.frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.all, 14).background(Color("BackgroundColor"))
    }
}
    
    struct Profile_Previews: PreviewProvider {
        static var previews: some View {
            UserPanel()
        }
    }

