//
//  Profile.swift
//  unistay
//
//  Created by Gustavo Amaro on 21/08/23.
//

import SwiftUI
struct User {
    var id: UUID = UUID()
    var name: String
    var surname: String
    var username: String
    var bio: String
    var amountOfConnections: Int
}

struct UserPanel: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var imageSize: CGFloat = 0
    @State private var selectedView: String = "Universities"
    var viewOptions = ["Universities", "Location", "Roommates"]
    var user: User = .init(name: "Lucca", surname: "Gray", username: "luccagray", bio: "Adventurous soul with a love for books and food. Let's connect and share our stories! 🌍📚🍽️", amountOfConnections: 14)
    @State private var selectionHeight: CGFloat = 0
    @State private var selectionWidth: CGFloat = 0
    
    @State var areDetailsExpanded: Bool = false
    @State var fullBio: Bool = false
    
    @State private var showSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    @StateObject var ImageDownloader = SignUpViewModel.ImageDownloader()
    var model = SignUpViewModel()
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            VStack {
                ZStack(alignment: .bottomLeading) {
                    Image("ProfileBackground").resizable().aspectRatio(contentMode: .fill).frame(width: width, height: 90).scaleEffect(1.15).clipped().cornerRadius(15)
                    if let image = ImageDownloader.downloadedImage {
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
                    ImageDownloader.downloadProfPic()
                    model.getUser {
                        userData, error in
                        if let userData = userData {
                                // Use userData
                                print(userData)
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
                                        styledText(type: "Regular", size: 14, content: user.bio).frame(maxWidth: width * 0.6).padding(.top, 8)
                                        Spacer()
                                    }
                                        Button (action: {
                                            fullBio.toggle()
                                        }) {
                                            HStack {
                                                styledText(type: "Regular", size: 14, content: "See \(user.name)'s full bio").foregroundColor(Color("Body"))
                                                Image(systemName: "doc.badge.ellipsis").foregroundColor(Color("Body"))
                                            }
                                        }
                                        HStack {
                                            styledText(type: "Semibold", size: 14, content: "\(user.amountOfConnections)")
                                            styledText(type: "Regular", size: 14, content: "Connections")
                                        }
                                }
                            },
                            label: { VStack(alignment: .leading, spacing: 2) {
                                styledText(type: "Semibold", size: 16, content: "\(user.name) \(user.surname)")
                                styledText(type: "Regular", size: 14, content: "@\(user.username)").foregroundColor(Color("Body"))
                            } }
                        ).tint(Color("BodyEmphasized"))
                    }.padding(.top, imageSize / 1.2)
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.bottom, 10)
                
                //Spacer()
                ZStack(alignment: .top) {
                    ScrollView {
                        Rectangle().frame(maxWidth: .infinity, maxHeight: selectionHeight).foregroundColor(.clear)
                        Suggestion(width: width).padding(.bottom, 20)
                        Universities(size: width, selectionSize: selectionHeight)
                    }//.padding(.top, selectionSize)
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
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.all, 14).background(Color("BackgroundColor")).edgesIgnoringSafeArea(.bottom).sheet(isPresented: $fullBio, content: {
            VStack(alignment: .trailing) {
                Button(action: {
                    fullBio.toggle()
                }) {
                    styledText(type: "Semibold", size: 14, content: "Done")
                }.alignmentGuide(.top, computeValue: { dimension in
                    1
                }).padding(.top, 34)
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        styledText(type: "Semibold", size: 14, content: "\(user.name)'s bio")
                        Image(systemName: "doc").foregroundColor(Color("Body"))
                    }
                    styledText(type: "Regular", size: 14, content: user.bio).modifier(GetHeightModifier(height: $sheetHeight))
                }.frame(maxWidth: 300)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity).presentationDetents([user.bio.count < 110 ? .fraction(0.35) : .medium, .medium, .large])
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
    
    struct Profile_Previews: PreviewProvider {
        static var previews: some View {
            UserPanel()
        }
    }

