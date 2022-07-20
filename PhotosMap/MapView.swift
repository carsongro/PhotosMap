//
//  MapView.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @ObservedObject var photos = PhotoCollection()
    @ObservedObject var photoList = PhotoList()
    
    @State private var newImage: UIImage?
    @State private var showSheet = false
    @State private var showPhotoList = false
    @State private var spreadImages = false
    @State private var selectedPhoto: Photo? = nil
    
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: viewModel.regionWrapper.region, showsUserLocation: true, annotationItems: photos.items) { location in
                    MapAnnotation(coordinate: location.location ?? CLLocationCoordinate2D()) {
                        VStack {
                            Image(uiImage: location.uiImage ?? UIImage())
                                .resizable()
                                .cornerRadius(50)
                                .padding(.all, 4)
                                .frame(width: 90, height: 90)
                                .background(.secondary)
                                .scaledToFill()
                                .clipShape(Circle())
                                .padding(8)
                                .clipped()
                            
                        }
                        .onTapGesture {
                            viewModel.region = viewModel.regionWrapper.region.wrappedValue
                            showPhotosInRange(location: location)
                        }
                    }
                }
                .ignoresSafeArea()
                .accentColor(Color(.systemPink))
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            AlbumView().environmentObject(photos).environmentObject(photoList)
                        } label: {
                            Image(systemName: "folder")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.leading)
                        }
                        
                        
                        Button {
                            locationFetcher.start()
                            newImage = nil
                            showSheet = true
                        } label: {
                            Image(systemName: "camera")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSheet, onDismiss: saveImage) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $newImage)
            }
            .sheet(isPresented: $showPhotoList) {
                PhotoListView(photos: photoList.photoList).environmentObject(photos).environmentObject(photoList)
            }
        }
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
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
