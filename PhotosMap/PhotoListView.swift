//
//  PhotoListView.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import SwiftUI
import CoreLocation

struct PhotoListView: View {
    @EnvironmentObject var photos: PhotoCollection
    
    var photo: Photo
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], alignment: .center) {
                ForEach(showPhotosInRangeTest(location: photo)) { photo in
                    NavigationLink {
                        PhotoDetailView(photo: photo).environmentObject(photos)
                    } label: {
                        Image(uiImage: photo.uiImage ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 1))
                            .shadow(radius: 10)
                            .padding([.horizontal, .vertical], 5)
                    }
                }
            }
        }
        .navigationTitle("Nearby Photos")
    }
    
    func showPhotosInRangeTest(location: Photo) -> [Photo]{
        // The commented out code filters the location based on the section of the map visible to the user, I instead opted to do it based on the distance from poinst relative to each other, but this is a cool way to do it as well! :)
//        photoList = photos.items.filter({ photo in
//            viewModel.region.center.longitude + viewModel.region.span.longitudeDelta > photo.longitude! && viewModel.region.center.latitude + viewModel.region.span.latitudeDelta > photo.latitude!
//        })
        photos.items.filter({ photo in
            photo.latitude! < location.latitude! + 0.014 && photo.longitude! < location.longitude! + 0.014
        })
    }
}

//struct PhotoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoListView(photos: Array<Photo>())
//    }
//}
