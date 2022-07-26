//
//  PhotoCollection.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import Foundation

class PhotoCollection: ObservableObject {
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
    @Published var items = [Photo]() {
        didSet {
            do {
                let data = try JSONEncoder().encode(items)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
    }
    
    init() {

        let file = "SavedPlaces"
        let url = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        
//        self.items = []
        
        guard let data = try? Data(contentsOf: url) else {
            items = []
            return
        }

        let decoder = JSONDecoder()
        guard let decodedPhotos = try? decoder.decode([Photo].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
                
        items = decodedPhotos
    }
    
    func append(_ item: Photo) {
        items.append(item)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
