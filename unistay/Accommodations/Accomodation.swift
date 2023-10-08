//
//  Accomodations.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct Accomodation: View {
    var pub: AccommodationResponse?
    var size: CGFloat
    var padding: CGFloat
    var geocoder = CLGeocoder()
    @State var name: String? = ""
    @State var country: String? = ""
    @ObservedObject var imageDownloader: ImageDownloader = ImageDownloader()
    var body: some View {
        NavigationLink(destination: ActiveAccommodation(pub: pub), label: {
            VStack(alignment: .center, spacing: 20) {
                if let firstImage = imageDownloader.image.first {
                    Image(uiImage: firstImage ?? UIImage()).resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.35, height: size * 0.35).scaleEffect(1.25).clipped().cornerRadius(20)
                }
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Image(systemName: "location.circle.fill")
                        if name != "" && country != "" {
                            Text("\(String(name?.prefix(3) ?? ""))... , \(country ?? "")").customStyle(size: 14)
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
            let defaults = UserDefaults.standard
            if let name = defaults.string(forKey: "name"), let country = defaults.string(forKey: "country") {
                self.name = name
                self.country = country
            } else {
                let location = CLLocation(latitude: pub?.location.latitude ?? 0, longitude: pub?.location.longitude ?? 0)
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    guard let placemark = placemarks?.first, error == nil else {
                        print("No placemark found: \(error?.localizedDescription ?? "Unknown Error")")
                        return
                    }
                    defaults.set(placemark.name, forKey: "name")
                    defaults.set(placemark.country, forKey: "country")
                    self.name = placemark.name
                    self.country = placemark.country
                }
            }
            let group = DispatchGroup()

            for img in pub?.images ?? [] {
                group.enter()
                imageDownloader.downloadImage(img) {
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                print(imageDownloader.image)
            }

            print(imageDownloader.image)
        }

    }
}

