//
//  ContentView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

struct CustomTextStyle: ViewModifier {
    var type: String
    var size: CGFloat
    var color: String

    func body(content: Content) -> some View {
        content
            .font(.custom("Eina03-\(type)", size: size))
            .foregroundColor(Color(color))
    }
}

extension Text {
    func customStyle(type: String = "Regular", size: CGFloat, color: String = "BodyEmphasized") -> some View {
        self.modifier(CustomTextStyle(type: type, size: size, color: color))
    }
}

func icon(name: String, size: CGFloat) -> some View {
    return Image(systemName: name).resizable().aspectRatio(contentMode: .fit).frame(width: size)
}

struct ContentView: View {
    @State private var searchText = ""
    @State var text: String = ""
    @State private var selectedFilters: [String] = []
    var filterOptions = ["option", "option 1", "option 2", "option 3"]
    @State private var isMenuOpen = false
    var viewOptions = ["Recommended", "Saved", "Connected"]
    @State private var selectedView: String = "Recommended"
    var views = ["Places", "Chats", "Profile", "Menu"]
    @State private var selectedTab = "Places"
    @State private var tabSize: CGFloat = 0
    @Binding var isLoggedIn: Bool
    @StateObject var user: User = User()
    var body: some View {
        GeometryReader {
            geometry in
            let size = geometry.size.width
            if user.accountType == "student" {
                ZStack(alignment: .bottom) {
                    if(selectedTab == "Places") {
                        Places(size: size, tabSize: tabSize)
                    } else if (selectedTab == "Menu") {
                        MenuView(size: size, tabSize: tabSize, isLoggedIn: $isLoggedIn)
                    } else if(selectedTab == "Profile") {
                        UserPanel(tabSize: tabSize)
                    } else if selectedTab == "Chats" {
                        Chats(user: user)
                    }
                    HStack(alignment: .bottom) {
                        ForEach(views, id:\.self) {
                            option in
                            unistay.tabItem(selectedTab: $selectedTab, option: option)
                        }
                    }.padding(.bottom, 38).padding(.top, 58).background(GeometryReader {
                        geo in
                        LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.62), endPoint: .top).onAppear {
                            tabSize = geo.size.height
                        }
                    })
                }.frame(maxHeight: .infinity).edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(true).padding(.horizontal, 18).padding(.top, 14).padding(.bottom, 0)
            } else {
                
            }
        }.background(Color("BackgroundColor")).onAppear {
            getUser {
                userData, error in
                if let userData = userData {
                    DispatchQueue.main.async {
                                self.user._id = userData._id
                                self.user.username = userData.username
                                self.user.name = userData.name
                                self.user.surname = userData.surname
                                self.user.email = userData.email
                                self.user.language = userData.language
                                self.user.password = userData.password
                                self.user.preferredLocations = userData.preferredLocations
                                self.user.isPrivate = userData.isPrivate
                                self.user.currency = userData.currency
                                self.user.savedPublications = userData.savedPublications
                                self.user.connectedPublications = userData.connectedPublications
                                self.user.owns = userData.owns
                                self.user.bio = userData.bio
                                self.user.profilePicture = userData.profilePicture
                                self.user.accountType = userData.accountType
                                self.user.locatedAt = userData.locatedAt
                            }
                    print(userData)
                    print(userData.username)
                    print (userData.preferredLocations[0].latitude)
                } else if let error = error {
                    print(error)
                }
            }
        }.environmentObject(user)
        
    }
}
    
