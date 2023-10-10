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
    @State var user: User?
    @State var message: String = ""
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    ForEach(chat.messages) {
                        msg in
                        if user?._id == msg.senderId {
                            Text(msg.content).background(Color("SearchBar"))
                        } else {
                            Text(msg.content).background(Color("AccentColor"))
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack(spacing: 8) {
                    TextInputField(input: $message, placeholderText: "Send a message", placeholderIcon: "text.bubble", required: false)
                    Button(action: {
                        
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

