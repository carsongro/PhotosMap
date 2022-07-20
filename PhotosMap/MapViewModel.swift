//
//  MapViewModel.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import MapKit
import SwiftUI

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var regionWrapper = RegionWrapper()
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        } else {
            print("Show alert to tell them to turn on location")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted likely due to parental controls.")
            case .denied:
                print("You have denied this app locaiton permission. Go into settings to change it.")
            case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
            regionWrapper.updateRegion(newRegion: region)
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

class RegionWrapper: ObservableObject {
    var _region: MKCoordinateRegion = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan)

    var region: Binding<MKCoordinateRegion> {
        Binding(
            get: { self._region },
            set: { self._region = $0 }
        )
    }
    
    func updateRegion(newRegion: MKCoordinateRegion) {
        withAnimation {
            region.wrappedValue = newRegion
            flag.toggle()
        }
    }

    @Published var flag = false
}

class PhotoList: ObservableObject {
    @Published var photoList = [Photo]()
}
