//
//  AlbumView.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import SwiftUI

struct AlbumView: View {
    @StateObject private var viewModel = AlbumViewModel()
    
    @EnvironmentObject var photos: PhotoCollection
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            if photos.items.isEmpty {
                Text("Photo album is empty.")
                    .font(.title.bold())
                    .foregroundColor(.secondary)
            }
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(photos.items) { photo in
                    ZStack {
                        if viewModel.showingEditor {
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
                                viewModel.selectedPhoto = photo
                                viewModel.showingDeleteConfirmation = true
                            }
                            .wiggling()
                        } else {
                            NavigationLink {
                                PhotoDetailView(photo: photo).environmentObject(photos)
                            } label: {
                                photo.image?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .alert("Are you sure you want to delete this photo?", isPresented: $viewModel.showingDeleteConfirmation) {
                        Button("Cancel", role: .cancel) {
                            viewModel.showingDeleteConfirmation = false
                            viewModel.showingEditor = true
                        }
                        Button("Delete", role: .destructive) {
                            deleteImage(viewModel.selectedPhoto ?? Photo(name: ""))
                        }
                    }
                }
            }
        }
        .toolbar {
            Button {
                viewModel.showingEditor.toggle()
            } label: {
                Text(viewModel.showingEditor ? "Done" : "Edit")
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
            viewModel.showingEditor = false
        } else {
            viewModel.showingEditor = true
        }
    }
}

//struct AlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumView()
//    }
//}
