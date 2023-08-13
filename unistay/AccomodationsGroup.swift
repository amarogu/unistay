//
//  AccomodationsGroup.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/08/23.
//

import SwiftUI

struct AccommodationData: Hashable {
    var location: String
    var rent: CGFloat
    var currency: String
    var rating: CGFloat
}

struct AccomodationsGroup: View {
    var accommodations: [AccommodationData] = [
        AccommodationData(location: "New York", rent: 2000, currency: "USD", rating: 4.5),
        AccommodationData(location: "Los Angeles", rent: 1500, currency: "USD", rating: 4.2),
        AccommodationData(location: "San Francisco", rent: 1800, currency: "USD", rating: 4.7),
        AccommodationData(location: "Chicago", rent: 1700, currency: "USD", rating: 4.0),
        AccommodationData(location: "Miami", rent: 2200, currency: "USD", rating: 4.8),
        AccommodationData(location: "Seattle", rent: 1900, currency: "USD", rating: 4.3),
        AccommodationData(location: "Austin", rent: 1600, currency: "USD", rating: 4.1),
        AccommodationData(location: "Boston", rent: 2100, currency: "USD", rating: 4.6)
        ]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var size: CGFloat
    var body: some View {
        
            ScrollView {
                HStack(alignment: .top) {
                    
                    VStack {
                        ForEach(accommodations, id: \.self) { accommodation in
                            if ((accommodations.firstIndex(of: accommodation)! + 1) % 2 != 0) {
                                Accomodation(AccommodationData: accommodation, size: size, padding: size <= 400 ? 3 : 8)
                            }
                            }
                    }
                    Spacer()
                    VStack {
                        ForEach(accommodations, id: \.self) { accommodation in
                            if ((accommodations.firstIndex(of: accommodation)! + 1) % 2 == 0) {
                                Accomodation(AccommodationData: accommodation, size: size, padding: size <= 400 ? 3 : 8)
                            }
                            }
                    }.padding(.top, 30)
                    
                }
                }
            }
        }
        




/*struct AccomodationsGroup_Previews: PreviewProvider {
    static var previews: some View {
        AccomodationsGroup()
        AccomodationsGroup().previewDevice("iPhone SE (3rd generation)")
    }
}*/
