//
//  Accomodations.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI
import CoreLocation
import MapKit
import Foundation
import Nuke
import NukeUI

struct Accomodation: View {
    var pub: AccommodationResponse?
    var size: CGFloat
    var padding: CGFloat
    var geocoder = CLGeocoder()
    @State var name: String? = ""
    @State var country: String? = ""
    @State var cover: UIImage?
    @State var images: [UIImage?] = []
    @EnvironmentObject var user: User
    var body: some View {
        NavigationLink(destination: ActiveAccommodation(pub: pub, location: [name, country], user: user), label: {
            VStack(alignment: .center, spacing: 20) {
                LazyImage(url: URL(string: "\(Global.shared.apiUrl)image/\(pub?.images[0] ?? "")")) {
                    i in
                    i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.35, height: size * 0.35).scaleEffect(1.25).clipped().cornerRadius(20)
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "location.circle.fill")
                        if name != "" && country != "" {
                            Text("\(String(name?.prefix(8) ?? ""))...").customStyle(size: 14)
                        } else {
                            Rectangle().foregroundStyle(Color("SearchBar")).frame(maxHeight: 20)
                        }
                    }
                    HStack {
                        
                        Text("\(pub?.currency ?? "") \(pub?.rent ?? 0)").customStyle(size: 14)
                        Text("/month").customStyle(size: 13).opacity(0.7)
                    }
                    HStack {
                        Image(systemName: "star.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 14)
                        
                        Text(String(format: "%.1f", pub?.rating ?? 10)).customStyle(size: 14)
                    }

                }
            }.padding(.all, 16).background(Color("Gray")).cornerRadius(20).padding(.vertical, 6)
        }).frame(maxWidth: size * 0.35 + 32).onAppear {
            let location = CLLocation(latitude: pub?.location.latitude ?? 0, longitude: pub?.location.longitude ?? 0)
            let locationKey = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            
            if let savedLocation = UserDefaults.standard.object(forKey: locationKey) as? [String: String] {
                self.name = savedLocation["name"]
                self.country = savedLocation["country"]
            } else {
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    guard let placemark = placemarks?.first, error == nil else {
                        print("No placemark found: \(error?.localizedDescription ?? "Unknown Error")")
                        return
                    }
                    self.name = placemark.name
                    self.country = placemark.country
                    
                    let locationData = ["name": self.name, "country": self.country]
                    UserDefaults.standard.set(locationData, forKey: locationKey)
                }
            }
        }

    }
}

