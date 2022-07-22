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
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: viewModel.regionWrapper.region, showsUserLocation: true, annotationItems: viewModel.photos.items) { location in
                    MapAnnotation(coordinate: location.location ?? CLLocationCoordinate2D()) {
                        VStack {
                            NavigationLink {
                                PhotoListView(photo: location).environmentObject(viewModel.photos)
                            } label: {
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
                            
                        }
                        .onTapGesture {
                            viewModel.region = viewModel.regionWrapper.region.wrappedValue
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
                            AlbumView().environmentObject(viewModel.photos).environmentObject(viewModel.photoList)
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
                            viewModel.locationFetcher.start()
                            viewModel.newImage = nil
                            viewModel.showSheet = true
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
            .sheet(isPresented: $viewModel.showSheet, onDismiss: viewModel.saveImage) {
                ImagePicker(sourceType: .camera, selectedImage: $viewModel.newImage)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
