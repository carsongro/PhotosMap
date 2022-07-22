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
    
    func showPhotosInRangeTest(location: Photo) -> [Photo] {
        photos.items.filter({ photo in
            (photo.latitude! < location.latitude! + 0.014 && photo.latitude! > location.latitude! - 0.014) && (photo.longitude! < location.longitude! + 0.014 && photo.longitude! > location.longitude! - 0.014)
        })
    }
}

//struct PhotoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoListView(photos: Array<Photo>())
//    }
//}
