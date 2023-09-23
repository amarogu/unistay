//
//  SearchBar.swift
//  unistay
//
//  Created by Gustavo Amaro on 22/09/23.
//

import SwiftUI
import MapKit

struct MapSearchBar: View {
    @StateObject var locationManager: LocationManager = .init()
    @State var navigationTag: String?
    var body: some View {
        NavigationView {
            GeometryReader {
                geo in
                let height = geo.size.height
                ZStack(alignment: .top) {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        
                        SearchBar(placeholder: styledText(type: "Regular", size: 13, content: "Find a place"), text: $locationManager.searchText).background(Color("SearchBar")).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 14)
                        
                        if let places = locationManager.fetchedPlaces, !places.isEmpty {
                            List {
                                ForEach(places, id: \.self) {
                                    place in
                                    Button(action: {
                                        if let coordinate = place.location?.coordinate {
                                            locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                            locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                            locationManager.addDraggablePin(coordinate: coordinate)
                                            locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                        }
                                        navigationTag = "MAPVIEW"
                                    }) {
                                        HStack(spacing: 15) {
                                            styledText(type: "Regular", size: 14, content: place.name ?? "")
                                            styledText(type: "Regular", size: 14, content: place.locality ?? "").opacity(0.8)
                                        }.padding(.vertical, 10)
                                    }
                                }.listRowBackground(Color("Gray").opacity(0.8).blur(radius: 5)).listRowSeparator(.hidden)
                            }.listStyle(.plain).cornerRadius(5).frame(maxHeight: height * 0.4)
                        } else {
                            if !locationManager.searchText.isEmpty {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }.padding(.all, 8).background(Color("SearchBar")).cornerRadius(5)
                            } else {
                                Button(action: {
                                    if let coordinate = locationManager.userLocation?.coordinate {
                                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                        locationManager.addDraggablePin(coordinate: coordinate)
                                        locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                    }
                                    navigationTag = "MAPVIEW"
                                }) {
                                    HStack(alignment: .center) {
                                        styledText(type: "Semibold", size: 14, content: "Use your urrent location").foregroundColor(Color("AccentColor"))
                                        Image(systemName: "location.north.circle").foregroundColor(Color("AccentColor"))
                                    }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)
                                }
                            }
                        }
                        
                    }.background {
                        NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                            MapViewSelection().environmentObject(locationManager).toolbarBackground(.visible, for: .automatic)
                        } label: {}.labelsHidden()
                    }.padding(.all, 30).zIndex(10)
                    /*MapViewSelection().environmentObject(locationManager).edgesIgnoringSafeArea(.all)*/
                }
            }
        }
    }
}

struct MapSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchBar()
    }
}

struct MapViewSelection: View {
    @EnvironmentObject var locationManager: LocationManager
    var body: some View {
        ZStack {
            MapViewHelper().environmentObject(locationManager).edgesIgnoringSafeArea(.all)
            
            if let place = locationManager.pickedPlacemark {
                VStack(alignment: .leading) {
                    Text("Confirm your location")
                    Text(place.name ?? "")
                    Text(place.locality ?? "")
                    Button(action: {
                        
                    }) {
                        Text("Confirm")
                    }
                }
            }
        }.onDisappear {
            locationManager.pickedLocation = nil
            locationManager.pickedPlacemark = nil
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
}

struct MapViewHelper: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}
