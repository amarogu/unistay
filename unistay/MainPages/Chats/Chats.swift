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
    @State var profilePicture: [String: UIImage?] = [:]
    @State var persistentChats: [Chat] = []
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Chats").customStyle(type: "Bold", size: 30)
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24))
                }.tint(Color("BodyEmphasized"))
            }
            List {
                ForEach(persistentChats) {
                    chat in
                    NavigationLink(destination: EmptyView()) {
                        HStack(spacing: 18) {
                            ZStack(alignment: .bottomLeading) {
                                ForEach(chat.participants) {
                                    participant in
                                    AsyncImage(url: URL(string: "http://localhost:3000/user/profilepicture/?id=\(participant._id)"))
                                    if let profPic = profilePicture[participant._id] {
                                        if participant._id == chat.participants[0]._id {
                                            Image(uiImage: profPic ?? UIImage()).resizable().aspectRatio(contentMode: .fill).frame(width: 58, height: 58).scaleEffect(1).clipShape(Circle()).opacity(0.85)
                                        }
                                        if participant._id == chat.participants[1]._id {
                                            Image(uiImage: profPic ?? UIImage()).resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).scaleEffect(1).clipShape(Circle()).offset(x: -8, y: 8)
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
                                        imageDownloader.downloadUserImage(participant._id) {
                                            img, error in
                                            profilePicture[participant._id] = img ?? UIImage()
                                        }
                                        /*profilePicture[participant._id] = AsyncImage(url: URL(string: "http://localhost:3000/user/profilepicture/?id=\(participant._id)"))*/
                                    }
                                }
                            }
                        }.padding(.vertical, 10)
                    }.listRowBackground(Color("BackgroundColor"))
                }
            }.listStyle(.plain).padding(.all, 0).onAppear {
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
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor"))
    }
}

#Preview {
    Chats()
}