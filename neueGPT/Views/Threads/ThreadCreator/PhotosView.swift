import SwiftUI
import PhotosUI

struct PhotosView: View {
	@State private var selectedImage: PhotosPickerItem?

	var body: some View {
		VStack {
			PhotosPicker("Select photo", selection: $selectedImage, matching: .images, preferredItemEncoding: .compatible)
				.photosPickerStyle(.inline)
				.photosPickerDisabledCapabilities(.selectionActions)
				.photosPickerAccessoryVisibility(.hidden)
				.padding(.top, 6)
				.padding(.horizontal, -20)
				.padding(.bottom, 6)
		}
	}
}

#Preview {
	PhotosView()
}
