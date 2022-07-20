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
    
    @ObservedObject var photos = PhotoCollection()
    @ObservedObject var photoList = PhotoList()
    
    @Published var newImage: UIImage?
    @Published var showSheet = false
    @Published var showPhotoList = false
    @Published var spreadImages = false
    @Published var selectedPhoto: Photo? = nil
    
    var locationManager: CLLocationManager?
    let locationFetcher = LocationFetcher()
    
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
    
    func showPhotosInRange(location: Photo) {
        // The commented out code filters the location based on the section of the map visible to the user, I instead opted to do it based on the distance from poinst relative to each other, but this is a cool way to do it as well! :)
//        photoList = photos.items.filter({ photo in
//            viewModel.region.center.longitude + viewModel.region.span.longitudeDelta > photo.longitude! && viewModel.region.center.latitude + viewModel.region.span.latitudeDelta > photo.latitude!
//        })
        photoList.photoList = photos.items.filter({ photo in
            photo.latitude! < location.latitude! + 0.014 && photo.longitude! < location.longitude! + 0.014
        })
        showPhotoList = true
    }
    
    func saveImage() {
        guard let newImage = newImage else { return }
        var newPhoto = Photo(name: "")
        newPhoto.writeToSecureDirectory(uiImage: newImage)
        if let location = self.locationFetcher.lastKnownLocation {
            newPhoto.setLocation(location: location)
        }
        photos.append(newPhoto)
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
