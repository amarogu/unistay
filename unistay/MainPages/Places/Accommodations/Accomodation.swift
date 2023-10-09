//
//  Accomodations.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI
import CoreLocation
import MapKit
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
    var body: some View {
        NavigationLink(destination: ActiveAccommodation(pub: pub, images: images, location: [name, country]), label: {
            VStack(alignment: .center, spacing: 20) {
                LazyImage(url: URL(string: "http://localhost:3000/image/\(pub?.images[0] ?? "")")) {
                    i in
                    i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.35, height: size * 0.35).scaleEffect(1.25).clipped().cornerRadius(20)
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
            let location = CLLocation(latitude: pub?.location.latitude ?? 0, longitude: pub?.location.longitude ?? 0)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard let placemark = placemarks?.first, error == nil else {
                    print("No placemark found: \(error?.localizedDescription ?? "Unknown Error")")
                    return
                }
                self.name = placemark.name
                self.country = placemark.country
            }
            if pub != nil {
                print("iterated")
                if cover == nil {
                    if images.isEmpty {
                        let group = DispatchGroup()
                        let urls = pub?.images ?? []
                        var downloadedImages: [UIImage?] = Array(repeating: nil, count: urls.count)
                        for (index, img) in urls.enumerated() {
                            group.enter()
                            NetworkManager.shared.download("http://localhost:3000/image/\(img)").responseURL { response in
                                debugPrint(response.fileURL as Any)
                                if let url = response.fileURL {
                                    let image = UIImage(contentsOfFile: url.path)
                                    DispatchQueue.main.async {
                                        downloadedImages[index] = image
                                        debugPrint(downloadedImages as Any)
                                        group.leave()
                                    }
                                } else {
                                    group.leave()
                                }
                            }
                        }
                        group.notify(queue: .main) {
                            self.images = downloadedImages
                        }
                    }
                }
            }
        }
    }
}

