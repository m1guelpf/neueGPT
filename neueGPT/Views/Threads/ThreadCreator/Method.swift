import SwiftUI

enum Method: CaseIterable, Identifiable {
	case photos
	case camera
	case keyboard
	case transcribe
	case talk

	var id: Method { self }

	var isLast: Bool {
		self == Method.allCases.last
	}

	func icon(selected: Method?) -> some View {
		if selected != self {
			return AnyView(
				Image(systemName: systemImage)
			)
		}

		return AnyView(
			Image(systemName: selectedIcon)
				.foregroundStyle(selectedColor)
				.symbolRenderingMode(.hierarchical)
				.font(self == .keyboard ? .title2 : .title)
		)
	}

	fileprivate var systemImage: String {
		switch self {
			case .photos:
				return "photo.stack.fill"
			case .camera:
				return "camera.fill"
			case .keyboard:
				return "keyboard.fill"
			case .transcribe:
				return "waveform.badge.mic"
			case .talk:
				return "headphones"
		}
	}

	var helpText: String? {
		switch self {
			case .photos:
				return "Select a picture"
			case .camera:
				return nil
			case .keyboard:
				return "Ask your question"
			case .transcribe:
				return "Start dictating"
			case .talk:
				return "Connecting..."
		}
	}

	fileprivate var selectedIcon: String {
		switch self {
			case .photos, .camera, .transcribe:
				return "arrow.up.circle.fill"
			case .keyboard:
				return "keyboard.chevron.compact.down.fill"
			case .talk:
				return "xmark.circle.fill"
		}
	}

	fileprivate var selectedColor: Color {
		switch self {
			case .photos, .camera, .transcribe:
				return .accentColor
			case .keyboard:
				return .primary
			case .talk:
				return .red
		}
	}
}

extension Method? {
	var usesSheet: Bool {
		self != nil && self != .keyboard
	}

	var sheetBackground: some View {
		if self != .camera {
			return AnyView(EmptyView())
		}

		return AnyView(
			CameraView()
				.ignoresSafeArea()
		)
	}

	var sheetContent: some View {
		switch self {
			case .photos:
				return AnyView(PhotosView())
			case .none, .keyboard, .camera:
				return AnyView(EmptyView())
			case .transcribe, .talk:
				return AnyView(
					Text(self!.helpText!)
						.foregroundStyle(Color.mutedSecondary)
				)
		}
	}

	func create(_: String) {
		//
	}
}
