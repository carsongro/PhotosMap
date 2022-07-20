//
//  PhotoDetailView.swift
//  PhotosMap
//
//  Created by Carson Gross on 7/20/22.
//

import SwiftUI

struct PhotoDetailView: View {
    @EnvironmentObject var photos: PhotoCollection
    @EnvironmentObject var photoList: PhotoList
    @State private var showDeleteAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    var photo: Photo
    
    var body: some View {
            VStack {
                ZoomableScrollView {
                    Image(uiImage: photo.uiImage ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Do you want to delete this photo?"),
                    message: Text("You cannot undo this action."),
                    primaryButton: .default(
                        Text("Cancel"),
                        action: cancelDelete
                    ),
                    
                    
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: deleteImage
                    )
                )
            }
            .toolbar {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
    
    func deleteImage() {
        if let photoIndex = photos.items.firstIndex(where: { $0.id == photo.id }) {
            photos.items[photoIndex].deleteFromSecureDirectory()
            photos.items.remove(at: photoIndex)
        }
        if let photoListIndex = photoList.photoList.firstIndex(where: { $0.id == photo.id }) {
            photoList.photoList.remove(at: photoListIndex)
        }
        showDeleteAlert = false
        dismiss()
    }
    
    func cancelDelete() {
        showDeleteAlert = false
    }
}

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
  private var content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = 20
    scrollView.minimumZoomScale = 1
    scrollView.bouncesZoom = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false

    // create a UIHostingController to hold our SwiftUI content
    let hostedView = context.coordinator.hostingController.view!
    hostedView.translatesAutoresizingMaskIntoConstraints = true
    hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    hostedView.frame = scrollView.bounds
    scrollView.addSubview(hostedView)

    return scrollView
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(hostingController: UIHostingController(rootView: self.content))
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
    // update the hosting controller's SwiftUI content
    context.coordinator.hostingController.rootView = self.content
    assert(context.coordinator.hostingController.view.superview == uiView)
  }

  // MARK: - Coordinator

  class Coordinator: NSObject, UIScrollViewDelegate {
    var hostingController: UIHostingController<Content>

    init(hostingController: UIHostingController<Content>) {
      self.hostingController = hostingController
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return hostingController.view
    }
  }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photo: Photo(name: ""))
    }
}
