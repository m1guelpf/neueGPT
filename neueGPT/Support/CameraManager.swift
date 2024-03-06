import AVFoundation

@Observable
class CameraManager {
	private let configQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).Camera.Config", target: .global(qos: .userInteractive))
	private let cameraQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).Camera.Priority", target: .global(qos: .userInitiated))

	var configured: Bool = false
	var session: AVCaptureSession = .init()
	var authorizationStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

	/// Stop the `AVCaptureSession` when the `CameraManager` is deinitialized
	deinit {
		self.stop()
	}

	/// Configure the `AVCaptureSession` if the app has camera access
	func prepare() {
		configQueue.sync {
			guard !configured, self.authorizationStatus == .authorized else { return }

			self.session.beginConfiguration()
			self.session.sessionPreset = .high

			let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

			guard let backCameraInput = try? AVCaptureDeviceInput(device: backCamera!), self.session.canAddInput(backCameraInput) else { fatalError("Something went wrong when setting up the camera") }
			self.session.addInput(backCameraInput)

			let photoOutput = AVCapturePhotoOutput()
			photoOutput.isLivePhotoCaptureEnabled = false

			guard session.canAddOutput(photoOutput) else { fatalError("Something went wrong when setting up the camera") }
			session.addOutput(photoOutput)

			self.session.commitConfiguration()

			configured = true
		}
	}

	/// Request camera access
	func requestAccess() async {
		if authorizationStatus == .notDetermined, await AVCaptureDevice.requestAccess(for: .video) {
			authorizationStatus = .authorized
			prepare()
		}
	}

	/// Prepare and start the `AVCaptureSession` if the app has camera access
	func startOnBackground() {
		guard authorizationStatus == .authorized else { return }

		prepare()
		start()
	}

	/// Start the `AVCaptureSession` if it's not already running
	func start() {
		if session.isRunning { return }

		cameraQueue.async {
			self.session.startRunning()
		}
	}

	/// Stop the `AVCaptureSession` if it's running
	func stop() {
		guard session.isRunning else { return }

		cameraQueue.async { self.session.stopRunning() }
	}
}
