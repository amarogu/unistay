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
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    ForEach(chat.messages) {
                        msg in
                        if user?._id == msg.senderId {
                            HStack {
                                Spacer()
                                VStack {
                                    HStack {
                                        Text(msg.content).customStyle(size: 14)
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        Text(formatTime(from: msg.createdAt)).customStyle(size: 12, color: "Body")
                                    }
                                }.padding(.vertical, 8.5).padding(.horizontal, 18).background(Color("AccentColor")).cornerRadius(5)
                            }.padding(.vertical, 1).padding(.horizontal, 20).padding(.leading, 24)
                            
                        } else {
                            HStack {
                                VStack {
                                    HStack {
                                        Text(msg.content).customStyle(size: 14)
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        Text(formatTime(from: msg.createdAt)).customStyle(size: 12, color: "Body")
                                    }
                                }.padding(.vertical, 8.5).padding(.horizontal, 18).background(Color("SearchBar")).cornerRadius(5)
                                Spacer()
                            }.padding(.vertical, 1).padding(.horizontal, 20).padding(.trailing, 24)
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.bottom, 68)
                HStack(spacing: 8) {
                    TextInputField(input: $message, placeholderText: "Send a message", placeholderIcon: "text.bubble", required: false)
                    Button(action: {
                        postMessage(to: chat._id, by: user?._id ?? "", content: message) {
                            result, error in
                        }
                        observableChat.fetchChats {
                            result, error in
                            for fetchedChat in result ?? [] {
                                if fetchedChat._id == chat._id {
                                    chat = fetchedChat
                                }
                            }
                        }
                    }) {
                        Image(systemName: "paperplane").font(.system(size: 15)).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColor")).tint(Color("BodyEmphasized")).cornerRadius(5)
                    }
                }.padding(.vertical, 14).padding(.horizontal, 20)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor")).toolbar {
            ToolbarItem {
                Text("Group").customStyle(type: "Semibold", size: 14)
            }
        }
    }
}

