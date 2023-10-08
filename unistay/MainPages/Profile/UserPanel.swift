//
//  Profile.swift
//  unistay
//
//  Created by Gustavo Amaro on 21/08/23.
//

import SwiftUI

class LocalUser {
    var _id: String = ""
    var username: String = ""
    var name: String = ""
    var surname: String = ""
    var email: String = ""
    var language: String = ""
    var password: String = ""
    var preferredLocations: [String] = []
    var isPrivate: Bool = false
    var currency: String = ""
    var savedPublications: [String] = []
    var connectedPublications: [String] = []
    var owns: [String] = []
    var profilePicture: String = ""
    var accountType: String = ""
    var bio: String = ""
    var __v: Int = 0
}

struct UserPanel: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var imageSize: CGFloat = 0
    @State private var selectedView: String = "Universities"
    var viewOptions = ["Universities", "Location", "Roommates"]
    @State private var user: User? = nil
    @State private var selectionHeight: CGFloat = 0
    @State private var selectionWidth: CGFloat = 0
    
    @State var areDetailsExpanded: Bool = false
    @State var fullBio: Bool = false
    
    @State private var showSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    @StateObject var downloader = ImageDownloader()
    
    var tabSize: CGFloat
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            VStack {
                ZStack(alignment: .bottomLeading) {
                    Image("ProfileBackground").resizable().aspectRatio(contentMode: .fill).frame(width: width, height: 90).scaleEffect(1.15).clipped().cornerRadius(15)
                    if let image = downloader.downloadedImage {
                        Image(uiImage: image).resizable().aspectRatio(contentMode: .fill).frame(width: width * 0.2, height: width * 0.2).scaleEffect(1).clipShape(Circle()).overlay(Circle().stroke(Color("Gray"), lineWidth: 3.5)).background(GeometryReader {
                            geo in
                            Color.clear.onAppear {
                                imageSize = geo.size.width
                            }
                        }).offset(.init(width: imageSize / 2, height: imageSize / 2))
                    } else {
                        Rectangle().frame(width: width * 0.2, height: width * 0.2).scaleEffect(1).clipShape(Circle()).overlay(Circle().stroke(Color("Gray"), lineWidth: 3.5)).background(GeometryReader {
                            geo in
                            Color.clear.onAppear {
                                imageSize = geo.size.width
                            }
                        }).offset(.init(width: imageSize / 2, height: imageSize / 2)).foregroundColor(Color("Gray"))
                    }
                }.frame(maxWidth: .infinity).background(Color("BackgroundColor")).onAppear {
                    downloader.downloadProfPic()
                    getUser {
                        userData, error in
                        if let userData = userData {
                                // Use userData
                                self.user = userData
                                print(userData)
                                print(userData.username)
                            print (userData.preferredLocations[0].latitude)
                            } else if let error = error {
                                // Handle error
                                print(error)
                            }
                    }
                }
                //Spacer()
                HStack (alignment: .center) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        DisclosureGroup(
                            isExpanded: $areDetailsExpanded,
                            content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        //checkCookies()
                                        if let bio = user?.bio {
                                            Text(bio).customStyle(size: 14).frame(maxWidth: width * 0.6).padding(.top, 8)
                                        }
                                        Spacer()
                                    }
                                        Button (action: {
                                            fullBio.toggle()
                                        }) {
                                            HStack {
                                                if let name = user?.name {
                                                    Text("See \(name)'s full bio").customStyle(size: 14)
                                                }
                                                Image(systemName: "doc.badge.ellipsis").foregroundColor(Color("Body"))
                                            }
                                        }
                                        HStack {
                                            if let connectedPublications = user?.connectedPublications {
                                                Text("\(connectedPublications.count)").customStyle(type: "Semibold", size: 14)
                                            }
                                            Text("Connections").customStyle(size: 14)
                                        }
                                }
                            },
                            label: { VStack(alignment: .leading, spacing: 2) {
                                if let name = user?.name, let surname = user?.surname, let username = user?.username {
                                    Text("\(name) \(surname)").customStyle(type: "Semibold", size: 14)
                                    Text("@\(username)").customStyle(size: 14, color: "Body")

                                }                            } }
                        ).tint(Color("BodyEmphasized"))
                    }.padding(.top, imageSize / 1.2)
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.bottom, 10)
                
                //Spacer()
                ZStack(alignment: .top) {
                    ScrollView {
                        Rectangle().frame(maxWidth: .infinity, maxHeight: selectionHeight).foregroundColor(.clear)
                        Suggestion(width: width).padding(.bottom, 20).padding(.top, selectionHeight)
                        if selectedView == "Universities" {
                            Universities(size: width, selectionSize: selectionHeight).padding(.bottom, tabSize)
                        } else if selectedView == "Location" {
                            
                        } else {
                            
                        }
                    }
                    Selection(viewOptions: viewOptions, selectedView: $selectedView).padding(.bottom, 20).background(GeometryReader {
                        geo in
                        LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: .init(x: 0.5, y: 0.1), endPoint: .bottom).onAppear {
                            selectionHeight = geo.size.height
                            selectionWidth = geo.size.width
                        }
                        
                    })//.padding(.top, 10)
                    
                }
                //Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor")).edgesIgnoringSafeArea(.bottom).sheet(isPresented: $fullBio, content: {
            VStack(alignment: .trailing) {
                Button(action: {
                    fullBio.toggle()
                }) {
                    Text("Done").customStyle(type: "Semibold", size: 14)
                }.alignmentGuide(.top, computeValue: { dimension in
                    1
                }).padding(.top, 34)
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        if let name = user?.name {
                            Text("\(name)'s bio").customStyle(type: "Semibold", size: 14)
                        }
                        Image(systemName: "doc").foregroundColor(Color("Body"))
                    }
                    if let bio = user?.bio {
                        Text(bio).customStyle(size: 14).modifier(GetHeightModifier(height: $sheetHeight))
                    }
                }.frame(maxWidth: 300)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity).presentationDetents([user?.bio.count ?? "".count < 110 ? .fraction(0.35) : .medium, .medium, .large])
        })
    }
}

struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

