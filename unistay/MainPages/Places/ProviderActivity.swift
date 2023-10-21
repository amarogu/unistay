//
//  ProviderActivities.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/10/23.
//

import SwiftUI

struct ProviderActivity: View {
    @State private var searchText = ""
    @State var text: String = ""
    @State private var selectedFilters: [String] = []
    var filterOptions = ["Bedrooms", "Bathrooms", "Guests", "Price range"]
    @State private var isMenuOpen = false
    var viewOptions = ["Recommended", "Saved", "Connected"]
    @State private var selectedView: String = "Recommended"
    var size: CGFloat
    var tabSize: CGFloat
    @State private var selectionSize: CGFloat = 0
    @State var pub: [AccommodationResponse] = []
    @EnvironmentObject var user: User
    @EnvironmentObject var webSocket: WebSocketManager
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            HStack(alignment: .center) {
                Text("Activity").customStyle(type: "Bold", size: 30)
                Spacer()
                Menu {
                    ForEach(filterOptions, id: \.self) {
                        option in
                        Button(action: {
                            
                            if(selectedFilters.contains(option)) {
                                selectedFilters.remove(at: selectedFilters.firstIndex(of: option) ?? -1)
                            } else {
                                selectedFilters.append(option)
                            }
                        }) {
                            Label(option, systemImage: selectedFilters.contains(option) ? "checkmark": "")
                        }
                    }
                    
                } label: {
                    Label(title: {Text("")}, icon: {Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24)).foregroundColor(/*@START_MENU_TOKEN@*/Color("BodyEmphasized")/*@END_MENU_TOKEN@*/)})
                }
            }//.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
            Spacer()
            /*SearchBar(searchText: $searchText).padding(.all, 10).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("SearchBar")/*@END_MENU_TOKEN@*/).cornerRadius(5)*/
            TextInputField(input: $text, placeholderText: "Search locations, accommodations...", placeholderIcon: "magnifyingglass", required: false)//.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
            Spacer()
            ZStack(alignment: .top) {
                
                ScrollView {
                    ProgressView().onAppear {
                        webSocket.receiveNewConnection()
                    }
                    ForEach(webSocket.newConn) {
                        conn in
                        Text(conn.username)
                    }
                }
                
                VStack(alignment: .leading) {
                    Selection(viewOptions: viewOptions, selectedView: $selectedView).padding(.bottom, 24).background(GeometryReader {
                        geo in
                        LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint: .bottom).onAppear {
                            selectionSize = geo.size.height
                        }
                    })//.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
                    Text("New connections").customStyle(type: "Semibold", size: 14)
                }
                
            }
        }.frame(maxWidth: .infinity).onAppear {
            Task {
                do {
                    let res = try await getYourPubs(user._id)
                    for publication in res {
                        pub.append(publication)
                    }
                } catch {
                    
                }
            }
        }.onDisappear {
            pub = []
        }
        }
}
