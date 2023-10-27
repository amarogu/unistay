//
//  LocationManager.swift
//  unistay
//
//  Created by Gustavo Amaro on 22/09/23.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
    @Published var userLocation: CLLocation?
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlacemark: CLPlacemark?
    
    override init() {
        super.init()
        manager.delegate = self
        mapView.delegate = self
        manager.requestWhenInUseAuthorization()
        cancellable = $searchText.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main).removeDuplicates().sink(receiveValue: {value in
            if value != "" {
                self.fetchPlaces(value: value)
            } else {
                self.fetchedPlaces = nil
            }
        })
    }
    
    func fetchPlaces(value: String) {
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({
                        item -> CLPlacemark in
                        return item.placemark
                    })
                })
            } catch {
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        self.userLocation = currentLocation
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func handleLocationError() {
        
    }
    
    func addDraggablePin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Select this location"
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PREFERREDLOCATION")
        marker.isDraggable = true
        marker.canShowCallout = false
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else {return}
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlacemark(location : CLLocation) {
        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: location) else {return}
                await MainActor.run(body: {
                    self.pickedPlacemark = place
                })
            } catch {
                
            }
        }
    }
    
    func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
}
