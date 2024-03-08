import Photos
import Foundation
import UIKit.UIImage

@Observable
class PhotosManager {
	var images = PHFetchResultCollection(fetchResult: .init())
	var imageCache = tap(PHCachingImageManager()) { $0.allowsCachingHighQualityImages = false }
	var authorizationStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)

	/// Request photos access if we haven't already
	func requestAuthorization() async {
		guard authorizationStatus == .notDetermined else { return }

		authorizationStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
	}

	/// Fetch all photos from the library if we have access and haven't already
	func fetchAllPhotos() {
		guard authorizationStatus == .authorized, images.isEmpty else { return }

		let fetchOptions = PHFetchOptions()
		fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared]
		fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

		DispatchQueue.main.async {
			self.images.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
		}
	}

	/// Fetch an image from the library by its local identifier
	func fetchImage(
		byLocalIdentifier localID: String,
		targetSize: CGSize = PHImageManagerMaximumSize,
		contentMode: PHImageContentMode = .default
	) async throws -> UIImage? {
		let results = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)

		guard let asset = results.firstObject else {
			fatalError("No asset found with the given local identifier \(localID)")
		}

		let options = tap(PHImageRequestOptions()) { options in
			options.resizeMode = .fast
			options.isSynchronous = true
			options.deliveryMode = .opportunistic
			options.isNetworkAccessAllowed = true
		}

		return try await withCheckedThrowingContinuation { [weak self] continuation in
			self?.imageCache.requestImage(
				for: asset,
				targetSize: targetSize,
				contentMode: contentMode,
				options: options,
				resultHandler: { image, info in
					if let errorInfo = info?[PHImageErrorKey], let error = errorInfo as? Error {
						continuation.resume(throwing: error)
						return
					}
					continuation.resume(returning: image)
				}
			)
		}
	}
}

struct PHFetchResultCollection: RandomAccessCollection, Equatable {
	typealias Element = PHAsset
	typealias Index = Int

	var fetchResult: PHFetchResult<PHAsset>

	var endIndex: Int { fetchResult.count }
	var startIndex: Int { 0 }

	subscript(position: Int) -> PHAsset {
		fetchResult.object(at: fetchResult.count - position - 1)
	}
}
