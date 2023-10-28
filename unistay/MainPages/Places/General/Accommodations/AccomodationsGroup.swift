//
//  AccomodationsGroup.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/08/23.
//

import SwiftUI
import MapKit

struct AccomodationsGroup: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var size: CGFloat
    var tabSize: CGFloat
    var selectionSize: CGFloat
    @Binding var pub: [AccommodationResponse?]
    @Binding var searchText: String
    @Binding var pickedLocCoordinates: [CLLocationDegrees?]
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(alignment: .top) {
                    if pub.isEmpty {
                        Text("There are not any accommodations within a 200km range of your preferred locations 😔").customStyle(size: 14).padding(.top, 30)
                    } else {
                        VStack {
                            ForEach(pub, id: \.self) { pubItem in
                                if ((pub.firstIndex(of: pubItem)! + 1) % 2 != 0) {
                                    Accomodation(pub: pubItem, size: size, padding: size <= 400 ? 3 : 8)
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
            }
        }.tint(Color("BodyEmphasized"))
    }
}
