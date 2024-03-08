import UIKit
import Photos
import SwiftUI

struct PhotosView: View {
	@Environment(PhotosManager.self) var photosManager: PhotosManager
	@State private var selectedImage: String?

	var body: some View {
		VStack {
			if photosManager.authorizationStatus == .authorized {
				ScrollView {
					LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 1), count: 3), spacing: 1) {
						ForEach(photosManager.images, id: \.self) { asset in
							Button(action: { selectImage(byLocalIdentifier: asset.localIdentifier) }) {
								PhotoThumbnailView(assetLocalID: asset.localIdentifier)
							}
							.buttonStyle(FlatButtonStyle())
							.overlay {
								if selectedImage == asset.localIdentifier {
									Color.background
										.allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
										.opacity(0.4)
										.overlay {
											Image(systemName: "checkmark.circle.fill")
												.font(.largeTitle)
												.foregroundColor(.primary)
										}
								}
							}
						}
					}
				}
				.padding(.top, 6)
				.padding(.horizontal, -20)
				.padding(.bottom, 6)
			} else {
				Text("Photos access is required to use this feature")
			}
		}
		.task {
			await photosManager.requestAuthorization()
			photosManager.fetchAllPhotos()
		}
	}

	func selectImage(byLocalIdentifier localIdentifier: String) {
		withAnimation(.smooth(duration: 0.15)) {
			selectedImage = selectedImage == localIdentifier ? nil : localIdentifier
		}
	}
}

struct PhotoThumbnailView: View {
	@State private var image: Image?
	@Environment(PhotosManager.self) var photosManager: PhotosManager

	var assetLocalID: String

	var body: some View {
		ZStack {
			if let image {
				GeometryReader { proxy in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: proxy.size.width, height: proxy.size.height)
						.clipped()
				}
				.aspectRatio(1, contentMode: .fill)
			} else {
				Rectangle()
					.foregroundColor(.secondary)
					.aspectRatio(1, contentMode: .fit)

				ProgressView()
			}
		}
		.onDisappear { image = nil }
		.task { await loadImageAsset() }
	}

	func loadImageAsset(
		targetSize: CGSize = PHImageManagerMaximumSize
	) async {
		guard let uiImage = try? await photosManager.fetchImage(byLocalIdentifier: assetLocalID, targetSize: targetSize) else {
			image = nil
			return
		}

		image = Image(uiImage: uiImage)
	}
}

#Preview {
	PhotosView()
		.environment(PhotosManager())
}
