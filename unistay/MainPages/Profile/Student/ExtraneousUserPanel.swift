//
//  ExtraneousUserPanel.swift
//  unistay
//
//  Created by Gustavo Amaro on 16/10/23.
//

import SwiftUI
import NukeUI

struct ExtraneousUserPanel: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var imageSize: CGFloat = 0
    @State private var selectedView: String = "Universities"
    var viewOptions = ["Universities", "Location", "Roommates"]
    @State var user: ExtraneousUser?
    @State var userId: String
    @State private var selectionHeight: CGFloat = 0
    @State private var selectionWidth: CGFloat = 0
    
    @State var areDetailsExpanded: Bool = false
    @State var fullBio: Bool = false
    
    @State private var showSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    var tabSize: CGFloat
    
    @State var editProfile: Bool = false
    @State var presented: Bool = false
    @State var croppedImage: UIImage?
    
    // edit profile inputs
    
    @State var updatedBio: String = ""
    @State var updatedUser: String = ""
    @State var updatedName: String = ""
    @State var updatedSurname: String = ""
    
    @State var responseAlert: String = ""
    @State var responseAlertTitle: String = ""
    @State var isAlertOn: Bool = false
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            VStack {
                ZStack(alignment: .bottomLeading) {
                    Image("ProfileBackground").resizable().aspectRatio(contentMode: .fill).frame(width: width, height: 90).scaleEffect(1.15).clipped().cornerRadius(15)
                    LazyImage(url: URL(string: "http://localhost:3000/getuserpicture/?id=\(userId)")) {
                        i in
                        i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: width * 0.2, height: width * 0.2).scaleEffect(1).clipShape(Circle()).overlay(Circle().stroke(Color("Gray"), lineWidth: 3.5)).background(GeometryReader {
                            geo in
                            Color.clear.onAppear {
                                imageSize = geo.size.width
                            }
                        }).offset(.init(width: imageSize / 2, height: imageSize / 2))
                    }
                }.frame(maxWidth: .infinity).background(Color("BackgroundColor"))
                //Spacer()
                HStack (alignment: .center) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        DisclosureGroup(
                            isExpanded: $areDetailsExpanded,
                            content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        //checkCookies()
                                        
                                        Text(user?.bio ?? "").customStyle(size: 14).padding(.top, 8).padding(.trailing, width * 0.4)
                                        
                                        Spacer()
                                    }
                                        Button (action: {
                                            fullBio.toggle()
                                        }) {
                                            HStack {
                                                
                                                Text("See \(user?.name ?? "")'s full bio").customStyle(size: 14)
                                                
                                                Image(systemName: "doc.badge.ellipsis").foregroundColor(Color("Body"))
                                            }
                                        }
                                        HStack {
                                            
                                            Text("\(user?.connectedPublications.count ?? 13)").customStyle(type: "Semibold", size: 14)
                                            
                                            Text("Connections").customStyle(size: 14)
                                        }
                                }
                            },
                            label: { VStack(alignment: .leading, spacing: 2) {
                               
                                Text("\(user?.name ?? "") \(user?.surname ?? "")").customStyle(type: "Semibold", size: 14)
                                Text("@\(user?.username ?? "")").customStyle(size: 14, color: "Body")

                                                         } }
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
                            Universities(size: width, selectionSize: selectionHeight).padding(.bottom, 24)
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
            
        }.padding(.horizontal, 18).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor")).edgesIgnoringSafeArea(.bottom).sheet(isPresented: $fullBio, content: {
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
                        
                        Text("\(user?.name ?? "")'s bio").customStyle(type: "Semibold", size: 14)
                        
                        Image(systemName: "doc").foregroundColor(Color("Body"))
                    }
                    
                    Text(user?.bio ?? "").customStyle(size: 14).modifier(GetHeightModifier(height: $sheetHeight))
                    
                }.frame(maxWidth: 300)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity).presentationDetents([user?.bio.count ?? 0 < 110 ? .fraction(0.35) : .medium, .medium, .large])
        }).onAppear {
            Task {
                do {
                    let response = try await getExtraneousUser(userId)
                    user = response
                } catch {
                    
                }
            }
        }
    }
}