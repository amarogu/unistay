//
//  Chats.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/10/23.
//

import SwiftUI
import NukeUI

struct Chats: View {
    @ObservedObject var observableChat: ObservableChat = ObservableChat()
    @State var user: User? = nil
    @State var persistentChats: [Chat] = []
    var body: some View {
        ZStack(alignment: .top) {
                List {
                    Rectangle().frame(height: 70).foregroundStyle(.clear).listRowBackground(Color("BackgroundColor"))
                    ForEach(persistentChats) {
                        chat in
                        NavigationLink(destination: ChatActive(chat: chat, user: user)) {
                            HStack(spacing: 18) {
                                ZStack(alignment: .bottomLeading) {
                                    ForEach(chat.participants) {
                                        participant in
                                            if participant._id == chat.participants[0]._id {
                                                LazyImage(url: URL(string: "http://localhost:3000/user/profilepicture/?id=\(participant._id)")) {
                                                    i in
                                                    i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 58, height: 58).scaleEffect(1).clipShape(Circle())
                                                }
                                            }
                                            if participant._id == chat.participants[1]._id {
                                                LazyImage(url: URL(string: "http://localhost:3000/user/profilepicture/?id=\(participant._id)")) {
                                                    i in
                                                    i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).scaleEffect(1).clipShape(Circle()).offset(x: -8, y: 8)
                                                }
                                            }
                                        
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text("Group with:").customStyle(size: 14)
                                    ForEach(chat.participants) {
                                        participant in
                                        HStack() {
                                            if user?._id != participant._id {
                                                
                                                Text("@\(participant.username)").customStyle(size: 14).padding(.vertical, 4).padding(.horizontal, 10).background(Color("AccentColor")).cornerRadius(5)
                                            }
                                        }.onAppear {
                                            /*imageDownloader.downloadUserImage(participant._id) {
                                                img, error in
                                                profilePicture[participant._id] = img ?? UIImage()
                                            }*/
                                            /*profilePicture[participant._id] = AsyncImage(url: URL(string: "http://localhost:3000/user/profilepicture/?id=\(participant._id)"))*/
                                        }
                                    }
                                }
                            }.padding(.vertical, 10)
                        }.listRowBackground(Color("BackgroundColor"))
                    }
                }.padding(.top, 20).listStyle(.plain).onAppear {
                    observableChat.fetchChats {
                        result, _ in
                        for chat in result ?? [] {
                            if persistentChats.isEmpty {
                                persistentChats.append(chat)
                            }
                        }
                    }
                    
                }
                /*ForEach(observableChat.chatsArray) {chat in
                    Text("Chat owned by \(chat.creator)")
                }*/
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Chats").customStyle(type: "Bold", size: 30)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24))
                    }.tint(Color("BodyEmphasized"))
                }
                Text("Chat with potential roommates and landlords")
            }.background(
                LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint: .bottom)
            ).frame(maxHeight: 90)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor"))
        
    }
}
