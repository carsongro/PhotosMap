//
//  PhotoListView.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import SwiftUI

struct PhotoListView: View {
    var photos: [Photo]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .center) {
                    ForEach(photos) { photo in
                        NavigationLink {
                            PhotoDetailView(photo: photo)
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
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView(photos: Array<Photo>())
    }
}
