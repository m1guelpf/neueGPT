import SwiftUI
import AVFoundation

struct CameraView: View {
	@Environment(CameraManager.self) var cameraManager: CameraManager

	var body: some View {
		VStack {
			if cameraManager.authorizationStatus == .authorized {
				Viewfinder(session: cameraManager.session)
			} else {
				Text("Camera access is required to use this feature")
			}
		}
		.onAppear { cameraManager.start() }
		.task { await cameraManager.requestAccess() }
	}
}

struct Viewfinder: UIViewRepresentable {
	let session: AVCaptureSession

	func makeUIView(context _: Context) -> VideoPreviewView {
		let view = VideoPreviewView()
		view.videoPreviewLayer.session = session
		view.videoPreviewLayer.videoGravity = .resizeAspectFill

		return view
	}

	func updateUIView(_: VideoPreviewView, context _: Context) {}

	class VideoPreviewView: UIView {
		override class var layerClass: AnyClass {
			AVCaptureVideoPreviewLayer.self
		}

		var videoPreviewLayer: AVCaptureVideoPreviewLayer {
			return layer as! AVCaptureVideoPreviewLayer
		}
	}
}

#Preview {
	CameraView()
}
