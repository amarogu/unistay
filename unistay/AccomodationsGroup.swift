//
//  AccomodationsGroup.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/08/23.
//

import SwiftUI

struct AccommodationData {
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
    var body: some View {
        Accomodation(AccommodationData: accommodations[0])
    }
}

struct AccomodationsGroup_Previews: PreviewProvider {
    static var previews: some View {
        AccomodationsGroup()
    }
}
