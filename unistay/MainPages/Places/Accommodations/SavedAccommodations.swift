//
//  SavedAccommodations.swift
//  unistay
//
//  Created by Gustavo Amaro on 24/10/23.
//

import SwiftUI
import MapKit

struct SavedAccommodations: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var size: CGFloat
    var tabSize: CGFloat
    var selectionSize: CGFloat
    @State private var pub: [AccommodationResponse?] = []
    @Binding var searchText: String
    @Binding var pickedLocCoordinates: [CLLocationDegrees?]
    @EnvironmentObject var user: User
    var body: some View {
        
            ScrollView {
                HStack(alignment: .top) {
                    if pub.isEmpty {
                        Text("There are not any accommodations within a 200km range of your preferred locations 😔").customStyle(size: 14).padding(.top, 30)
                    } else {
                        VStack {
                            ForEach(pub, id: \.self) { pubItem in
                                if ((pub.firstIndex(of: pubItem)! + 1) % 2 != 0) {
                                    NavigationLink(destination: ActiveAccommodation(pub: pub, location: [name, country], user: user) {
                                        Accomodation(pub: pubItem, size: size, padding: size <= 400 ? 3 : 8)
                                    }
                                    
                                }
                            }
                        }
                        Spacer()
                        VStack {
                            ForEach(pub, id: \.self) { pubItem in
                                if ((pub.firstIndex(of: pubItem)! + 1) % 2 == 0) {
                                    Accomodation(pub: pubItem, size: size, padding: size <= 400 ? 3 : 8)
                                }
                            }
                        }.padding(.top, 30)
                    }
                }.padding(.bottom, tabSize).padding(.top, selectionSize - 30)
            }.tint(Color("BodyEmphasized")).onAppear {
                if pub == [] {
                    getPubs {
                        pubData, error in
                        for pubData in pubData {
                            if let pubData = pubData {
                                for saved in user.savedPublications {
                                    if saved == pubData._id {
                                        self.pub.append(pubData)
                                    }
                                }
                                print(pubData.title)
                            } else if let error = error {
                                print(error)
                            }
                        }
                    }
                }
            }.onChange(of: pickedLocCoordinates) {
                if pickedLocCoordinates == [] {
                    if pub == [] {
                        getPubs {
                            pubData, error in
                            for pubData in pubData {
                                if let pubData = pubData {
                                    for saved in user.savedPublications {
                                        if saved == pubData._id {
                                            self.pub.append(pubData)
                                        }
                                    }
                                    print(pubData.title)
                                } else if let error = error {
                                    print(error)
                                }
                            }
                        }
                    }
                } else {
                    pub = []
                    if pub == [] {
                        Task {
                            do {
                                let res = try await getNearestTo(pickedLocCoordinates[0] ?? 0, pickedLocCoordinates[1] ?? 0)
                                DispatchQueue.main.async {
                                    for pub in res {
                                        for saved in user.savedPublications {
                                            if saved == pub._id {
                                                self.pub.append(pub)
                                            }
                                        }
                                    }
                                }
                            } catch {
                                
                            }
                        }
                    }
                }
            }
        
    }
}
