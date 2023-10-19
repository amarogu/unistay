//
//  ChatActive.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/10/23.
//

import SwiftUI
import NukeUI

struct ChatActive: View {
    @State var chat: Chat
    @ObservedObject var observableChat: ObservableChat = ObservableChat()
    @State var user: User?
    @State var message: String = ""
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @StateObject var webSocket: WebSocketManager
    func formatTime(from dateString: String) -> String {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let date = isoFormatter.date(from: dateString)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            if let date = date {
                return timeFormatter.string(from: date)
            } else {
                return ""
            }
        }
    
    @State private var scrollTarget: UUID?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollViewReader {
                    scrollView in
                    ScrollView {
                            ForEach(chat.messages) {
                                msg in
                                if user?._id == msg.senderId {
                                    HStack() {
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            HStack {
                                                Text(msg.content).customStyle(size: 14, color: "BodyAccent")
                                                
                                            }.padding(.bottom, 4)
                                            Text(getUsername(msg.senderId, chat)).customStyle(type: "Semibold", size: 12, color: "BodyAccent")
                                            HStack {
                                                
                                                Text(formatTime(from: msg.createdAt)).customStyle(size: 12, color: "BodyAccent")
                                            }
                                        }.padding(.vertical, 8.5).padding(.horizontal, 18).background(Color("AccentColor")).cornerRadius(5)
                                    }.padding(.vertical, 1).padding(.horizontal, 20)
                                    
                                } else {
                                    HStack {
                                        VStack(alignment: .trailing) {
                                            HStack {
                                                Text(msg.content).customStyle(size: 14)
                                                
                                            }.padding(.bottom, 4)
                                            Text(getUsername(msg.senderId, chat)).customStyle(type: "Semibold", size: 12, color: "Body")
                                            HStack {
                                                
                                                Text(formatTime(from: msg.createdAt)).customStyle(size: 12, color: "Body")
                                            }
                                        }.padding(.vertical, 8.5).padding(.horizontal, 18).background(Color("SearchBar")).cornerRadius(5)
                                        Spacer()
                                    }.padding(.vertical, 1).padding(.horizontal, 20)
                                }
                            }.onChange(of: chat.messages.count) { _ in
                                scrollTarget = chat.messages.last?.id
                            }.onChange(of: scrollTarget) { target in
                                if let target = target {
                                    scrollView.scrollTo(target, anchor: .bottom)
                                }
                            }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.bottom, 68).defaultScrollAnchor(.bottom)
                }
                HStack(spacing: 8) {
                    TextInputField(input: $message, placeholderText: "Send a message", placeholderIcon: "text.bubble", required: false)
                    Button(action: {
                        webSocket.sendMessage(message)
                        
                        let group = DispatchGroup()
                        
                        if message.isEmpty {
                            return
                        }
                        
                            group.enter()
                            postMessage(to: chat._id, by: user?._id ?? "", content: message) { result, error in
                                group.leave()
                            }

                            group.notify(queue: .main) {
                                observableChat.fetchChats { result, error in
                                    for fetchedChat in result ?? [] {
                                        if fetchedChat._id == chat._id {
                                            chat = fetchedChat
                                        }
                                    }
                                }
                                message = ""
                            }
                    }) {
                        Image(systemName: "paperplane").font(.system(size: 15)).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColor")).tint(Color("BodyAccent")).cornerRadius(5)
                    }
                }.padding(.vertical, 14).padding(.horizontal, 20)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor")).toolbar {
            ToolbarItem {
                Text("Group").customStyle(type: "Semibold", size: 14)
            }
        }.onAppear {
            webSocket.receiveMessage()
        }
    }
}

func getUsername(_ id: String, _ chat: Chat?) -> String {
    for user in chat?.participants ?? [] {
        if id == user._id {
            return user.username
        }
    }
    
    return ""
}
