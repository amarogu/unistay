//
//  Chats.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/10/23.
//

import SwiftUI
import NukeUI
import Nuke

struct Chats: View {
    @EnvironmentObject var observableChat: ObservableChat
    @State var chatsArray: [Chat]? = []
    @State var user: User? = nil
    @EnvironmentObject var webSocket: WebSocketManager
    
    @State var title: String = ""
    @State var msg: String = ""
    @State var presented: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
                List {
                    Rectangle().frame(height: 70).foregroundStyle(.clear).listRowBackground(Color("BackgroundColor"))
                    ForEach(chatsArray ?? []) {
                        chat in
                        NavigationLink(destination: ChatActive(chat: chat, webSocket: webSocket, user: user)) {
                            HStack(spacing: 18) {
                                ZStack(alignment: .bottomLeading) {
                                    ForEach(chat.participants) {
                                        participant in
                                            if participant._id == chat.participants[0]._id {
                                                LazyImage(url: URL(string: "\(Global.shared.apiUrl)getuserpicture/?id=\(participant._id)")) {
                                                    i in
                                                    i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 58, height: 58).scaleEffect(1).clipShape(Circle())
                                                }.onAppear {
                                                    let url = URL(string: "\(Global.shared.apiUrl)getuserpicture/?id=\(participant._id)")
                                                    let request = ImageRequest(url: url)
                                                    ImageCache.shared[ImageCacheKey(request: request)] = nil
                                                }
                                            }
                                            if participant._id == chat.participants[1]._id {
                                                LazyImage(url: URL(string: "\(Global.shared.apiUrl)getuserpicture/?id=\(participant._id)")) {
                                                    i in
                                                    i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).scaleEffect(1).clipShape(Circle()).offset(x: -8, y: 8)
                                                }.onAppear {
                                                    let url = URL(string: "\(Global.shared.apiUrl)getuserpicture/?id=\(participant._id)")
                                                    let request = ImageRequest(url: url)
                                                    ImageCache.shared[ImageCacheKey(request: request)] = nil
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
                                                
                                                Text("@\(participant.username)").customStyle(size: 14, color: "BodyAccent").padding(.vertical, 4).padding(.horizontal, 10).background(Color("AccentColor")).cornerRadius(5)
                                            }
                                        }
                                    }
                                }
                            }.padding(.vertical, 10)
                        }.contextMenu {
                            Button(action: {
                                print(chat.creator)
                                print(user?._id)
                                Task {
                                    do {
                                        if chat.creator == user?._id {
                                            let res = try await dropChat(chat._id)
                                            if res.message == "Chat deleted successfully" {
                                                title = "Success"
                                                msg = "This chat has been deleted and no other users in it can see it anymore"
                                                presented = true
                                                chatsArray?.removeAll(where: { $0._id == chat._id })
                                            } else {
                                                title = "Error"
                                                msg = res.message
                                                presented = true
                                            }
                                        } else {
                                            let res = try await leaveChat(chat._id)
                                            if res.message == "User removed from chat successfully" {
                                                title = "Success"
                                                msg = "You have left this chat and it will no longer show up for you"
                                                presented = true
                                            } else {
                                                title = "Error"
                                                msg = res.message
                                                presented = true
                                            }
                                        }
                                    } catch {
                                        print(error)
                                    }
                                }
                            }) {
                                if chat.creator == user?._id {
                                    Image(systemName: "trash")
                                    Text("Delete chat").customStyle(size: 14)
                                } else {
                                    Text("Leave chat").customStyle(size: 14)
                                    Image(systemName: "trash")
                                }
                            }
                        }.listRowBackground(Color("BackgroundColor"))
                    }
                }.padding(.top, 20).listStyle(.plain) // TODO: Check if this does not remove the chat that is being sent to the ActiveChat view
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
                Text("Chat with potential roommates and landlords").lineLimit(1)
            }.frame(maxHeight: 100).padding(.bottom, 40).padding(.trailing, 10).background(
                LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.65), endPoint: .bottom)
            )
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor")).onAppear {
            observableChat.fetchChats {
                fetchedChats, err in
                chatsArray = fetchedChats
            }
        }.onReceive(webSocket.$fetchChat) { fetchChat in
            if fetchChat {
                print("received in here")
                observableChat.fetchChats {
                    fetchedChats, err in
                    chatsArray = fetchedChats
                }
            }
        }.alert(title, isPresented: $presented, actions: {
            Button(action: {}) {
                Text("Ok")
            }
        }, message: {
            Text(msg).customStyle(size: 14)
        })

        
    }
}
