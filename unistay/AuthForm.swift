//
//  AuthForm.swift
//  unistay
//
//  Created by Gustavo Amaro on 27/08/23.
//

import SwiftUI

struct AuthForm: View {
    /*@Binding var text: [[String]]
    var fields: [[String]]// = ["E-mail address", "Password"]
    var icons: [[String]]// = ["envelope", "key"]
    @State var titleHeight: CGFloat = 0
    @State var subtitleHeight: CGFloat = 0
    var width: CGFloat
    @Environment(\.colorScheme) private var colorScheme
    var title: String
    var links: [String]
    var linkIcons: [String]?
    var destinations: [AnyView]?
    var action: () -> String
    var languages: [String] = ["System language", "English", "Portuguese", "French"]
    @State private var selectedLanguage: String = "System language"
    @State private var errorMessage: String = ""
    @State var step: Int
    //@Binding var step: Int*/
    @Binding var userInsertedContent: [String: [String: String]]
        var fields: [String: [String]]
        var icons: [String: [String]]
        @Environment(\.colorScheme) private var colorScheme
        @State var titleHeight: CGFloat = 0
        @State var subtitleHeight: CGFloat = 0
        var width: CGFloat
        var title: String
        var links: [String]
        var linkIcons: [String]?
        var destinations: [AnyView]?
        var action: () -> String
        var languages: [String] = ["System language", "English", "Portuguese", "French"]
        @State private var selectedLanguage: String = "System language"
        @State private var errorMessage: String = ""
        @State var step: Int
    
    var body: some View {
        
            NavigationView {
                ZStack {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 24, height: 24)
                                styledText(type: "Bold", size: 22, content: "UniStay").background(GeometryReader {
                                    geo in
                                    Color.clear.onAppear {
                                        subtitleHeight = geo.size.height
                                    }
                                    
                                })
                            }.padding(.bottom, 4)
                            HStack {
                                styledText(type: "Bold", size: 34, content: title).background(GeometryReader {
                                    geo in
                                    Color.clear.onAppear {
                                        titleHeight = geo.size.height
                                    }
                                    
                                })
                                Spacer()
                                Menu {
                                    ForEach(languages, id: \.self) {
                                        language in
                                        Button(action: {
                                            selectedLanguage = language
                                        }) {
                                            Label(language, systemImage: selectedLanguage == language ? "checkmark" : "")
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "globe").foregroundColor(Color("Body"))
                                        Image(systemName: "chevron.down").foregroundColor(Color("Body"))
                                    }
                                }
                            }.frame(height: titleHeight).padding(.bottom, 10)
                            
                            Button(action: {
                                errorMessage = action()
                            }) {
                                HStack(alignment: .center) {
                                    styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                    Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1))//.cornerRadius(5)
                            }.padding(.bottom, 10)
                            if errorMessage.isEmpty {
                                EmptyView()
                            } else {
                                styledText(type: "Regular", size: 14, content: errorMessage).foregroundColor(.red)
                            }
                            /*if (!links.isEmpty && !destinations.isEmpty) {
                                ForEach(links, id: \.self) {
                                    link in
                                    
                                    NavigationLink(destination: destinations[links.firstIndex(of: link)!]) {
                                        HStack {
                                            styledText(type: "Regular", size: 14, content: link).foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                            Image(systemName: linkIcons[links.firstIndex(of: link)!]).foregroundColor(Color("BodyEmphasized"))
                                        }
                                    }
                                    
                                    
                                }
                            }*/
                            if let destinations = destinations, !links.isEmpty {
                                ForEach(links.indices, id: \.self) { index in
                                    NavigationLink(destination: destinations[index]) {
                                        HStack {
                                            styledText(type: "Regular", size: 14, content: links[index]).foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                            Image(systemName: linkIcons?[index] ?? "").foregroundColor(Color("BodyEmphasized"))
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
            }.tint(Color("BodyEmphasized"))
        }
    }




