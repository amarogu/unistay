//
//  Chats.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/10/23.
//

import SwiftUI

struct Chats: View {
    @ObservedObject var observableChat: ObservableChat = ObservableChat()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Chats").customStyle(type: "Bold", size: 30)
                Spacer()
                Button(action: {
                    observableChat.fetchChats {
                        _, _ in
                    }
                }) {
                    Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24))
                }.tint(Color("BodyEmphasized"))
            }
            ForEach(observableChat.chatsArray) {chat in
                Text("Chat owned by \(chat.creator)")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.all, 18).background(Color("BackgroundColor"))
    }
}

#Preview {
    Chats()
}
