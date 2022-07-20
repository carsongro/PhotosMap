//
//  AlbumView.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import SwiftUI

struct AlbumView: View {
    @EnvironmentObject var photos: PhotoCollection
    
    @State private var showImageView = false
    @State private var tappedPhoto: Photo? = nil
    @State private var selectedPhoto: Photo? = nil
    @State private var showingEditor = false
    @State private var showingDeleteConfirmation = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(photos.items) { photo in
                    ZStack {
                        if showingEditor {
                            ZStack {
                                photo.image?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
                                    .clipped()
                                    .cornerRadius(10)
                                
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.red)
                                    .shadow(radius: 15)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
                            }
                            .onTapGesture {
                                selectedPhoto = photo
                                showingDeleteConfirmation = true
                            }
                            .wiggling()
                        } else {
                            NavigationLink {
                                PhotoDetailView(photo: photo)
                            } label: {
                                photo.image?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .alert("Are you sure you want to delete this photo?", isPresented: $showingDeleteConfirmation) {
                        Button("Cancel", role: .cancel) {
                            showingDeleteConfirmation = false
                            showingEditor = true
                        }
                        Button("Delete", role: .destructive) {
                            deleteImage(selectedPhoto ?? Photo(name: ""))
                        }
                    }
                }
            }
        }
        .toolbar {
            Button {
                showingEditor.toggle()
            } label: {
                Text(showingEditor ? "Done" : "Edit")
            }
        }
        .navigationTitle("Photo Album")
    }
    
    func deleteImage(_ photo: Photo) {
        if let photoIndex = photos.items.firstIndex(where: { $0.id == photo.id }) {
            photos.items[photoIndex].deleteFromSecureDirectory()
            photos.items.remove(at: photoIndex)
        }
        if photos.items.isEmpty {
            showingEditor = false
        } else {
            showingEditor = true
        }
    }
    
    func cancelDelete() {
        showingDeleteConfirmation = false
    }
}

//struct AlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumView()
//    }
//}
