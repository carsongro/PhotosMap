//
//  AlbumViewModel.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import SwiftUI

final class AlbumViewModel: ObservableObject {
    @EnvironmentObject var photos: PhotoCollection
    @EnvironmentObject var photoList: PhotoList
    
    @Published var showImageView = false
    @Published var tappedPhoto: Photo? = nil
    @Published var selectedPhoto: Photo? = nil
    @Published var showingEditor = false
    @Published var showingDeleteConfirmation = false
    
    func cancelDelete() {
        showingDeleteConfirmation = false
    }
}
