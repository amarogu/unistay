//
//  tabItem.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI

struct tabItem: View {
    @Binding private var selectedTab: String
    var option: String
    init(selectedTab: Binding<String>, option: String) {
        self._selectedTab = selectedTab
        self.option = option
    }
    @EnvironmentObject var webSocket: WebSocketManager
    @State var isActive: Bool = false
    
    @State var notified: Bool = false
    @State var chatNotified: Bool = false
    var body: some View {
        VStack {
            Button(action: {
                selectedTab = option
                isActive.toggle()
                if option == "Places" {
                    notified = false
                } else {
                    chatNotified = false
                }
                
            }) {
                VStack(spacing: 8) {
                    if (option == "Places") {
                        VStack {
                            if notified {
                                Circle().frame(width: 8, height: 8).foregroundStyle(Color("Error")).transformEffect(.init(translationX: 14, y: 10))
                            }
                            Image(systemName: "house").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                        }
                    } else if (option == "Chats") {
                        VStack {
                            if chatNotified {
                                Circle().frame(width: 8, height: 8).foregroundStyle(Color("Error")).transformEffect(.init(translationX: 14, y: 10))
                            }
                            Image(systemName: "bubble.left.and.bubble.right").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                        }
                    } else if (option == "Profile") {
                        Image(systemName: "person.crop.circle").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                    } else {
                        Image(systemName: "line.3.horizontal").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                    }
                    Text(option).customStyle(size: 14)
                }
            }.symbolEffect(.bounce.up.byLayer, value: isActive)
        }.frame(maxWidth: .infinity).onChange(of: webSocket.newConnArray) {
            _ in
            notified = true
        }.onChange(of: webSocket.newReqArray) {
            _ in
            notified = true
        }.onReceive(webSocket.$fetchChat) {
            fetchChat in
            if fetchChat {
                chatNotified = true
            }
        }
    }
}

