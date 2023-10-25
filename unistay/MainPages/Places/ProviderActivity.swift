//
//  ProviderActivities.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/10/23.
//

import SwiftUI
import NukeUI

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
                    VStack {
                        if webSocket.newConn {
                            Text("Received")
                        }
                        ForEach(webSocket.newConnArray) {
                                newConn in
                            Text("New conn detected")
                                HStack(spacing: 14) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(newConn.newUser.name).customStyle(size: 14)
                                        Text(newConn.publication.description).customStyle(size: 14, color: "Body").lineLimit(2)
                                    }
                                    Spacer()
                                    LazyImage(url: URL(string: "http://localhost:3000/image/\(newConn.publication.images[0])")) {
                                        i in
                                        i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.1, height: size * 0.1).scaleEffect(1.25).clipped().cornerRadius(5)
                                    }
                                }.padding(.vertical, 10).padding(.horizontal, 14).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 4)
                            }
                        
                    }.padding(.top, selectionSize + 14).padding(.bottom, tabSize)
                }
                
                VStack {
                    HStack {
                        Text("New connections").customStyle(type: "Semibold", size: 14)
                        Spacer()
                    }
                }.frame(maxWidth: .infinity).background(GeometryReader {
                    geo in
                    LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint: .bottom).onAppear {
                        selectionSize = geo.size.height
                    }
                })
                
            }
        }.frame(maxWidth: .infinity).onAppear {
            Task {
                            do {
                                let newConn = try await webSocket.receiveNewConnection()
                                webSocket.newConnArray.append(newConn)
                            } catch {
                                print("Error receiving new connection: \(error)")
                            }
                        }
        }
        }
}
