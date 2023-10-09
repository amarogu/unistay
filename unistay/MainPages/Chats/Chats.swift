//
//  Chats.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/10/23.
//

import SwiftUI

struct Chats: View {
    @ObservedObject var observableChat: ObservableChat = ObservableChat()
    @ObservedObject var imageDownloader: ImageDownloader = ImageDownloader()
    @State var user: User? = nil
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Chats").customStyle(type: "Bold", size: 30)
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24))
                }.tint(Color("BodyEmphasized"))
            }.padding(.all, 18)
            List {
                ForEach(observableChat.chatsArray) {
                    chat in
                    VStack(alignment: .leading) {
                        Text("Chat with").customStyle(size: 14)
                        HStack {
                            ForEach(chat.participants) {
                                participant in
                                if user?._id != participant._id {
                                    Text(participant.username).customStyle(size: 14).padding(.vertical, 4).padding(.horizontal, 8).background(Color("AccentColor")).cornerRadius(5)
                                }
                            }
                        }
                    }.padding(.vertical, 10).listRowBackground(Color("BackgroundColor"))
                }
            }.listStyle(.plain).padding(.all, 0)
            /*ForEach(observableChat.chatsArray) {chat in
                Text("Chat owned by \(chat.creator)")
            }*/
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor")).onAppear {
            observableChat.fetchChats {
                _, _ in
            }
            
        }
    }
}

#Preview {
    Chats()
}
